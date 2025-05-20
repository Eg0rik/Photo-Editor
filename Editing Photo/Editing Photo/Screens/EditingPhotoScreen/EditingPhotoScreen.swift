//
//  EditingPhotoScreen.swift
//  Editing Photo
//
//  Created by mac on 19.05.25.
//

import SwiftUI
import PencilKit
import CoreImage
import CoreImage.CIFilterBuiltins

struct EditingPhotoScreen: View {
    @EnvironmentObject var appCoordinator: AppCoordinator
    @StateObject var viewModel = EditingPhotoViewModel()
    
    @State private var currentToolPanel: ToolPanelType = .hidePanel
    @State private var currentFilter: FilterType = .original
    @State private var drawing = PKDrawing()
    @State private var canvasView = PKCanvasView()
    @State private var currentScale: CGFloat = 1.0
    @State private var currentAngle: Angle = .zero
    @State private var showWarningAlert: Bool = false
    @State private var filterIntensity = 0.5
    @State private var image: Image
    @State private var showAlertGoToSettings = false
    
    @State private var uiImage: UIImage {
        didSet {
            image = Image(uiImage: uiImage)
        }
    }
    
    private let context = CIContext()
    private let originalUIImage: UIImage
    
    init(uiImage: UIImage) {
        self.uiImage = uiImage
        self.originalUIImage = uiImage
        self.image = Image(uiImage: uiImage)
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                let fittedFrame = fittedRect(for: uiImage.size, in: geometry.size)
                
                ZStack {
                    ZStack {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: fittedFrame.width, height: fittedFrame.height)
                            .position(x: fittedFrame.midX, y: fittedFrame.midY)
                        
                        CanvasView(
                            drawing: $drawing,
                            currentToolPanel: $currentToolPanel,
                            canvasView: $canvasView
                        )
                        .frame(width: fittedFrame.width, height: fittedFrame.height)
                        .position(x: fittedFrame.midX, y: fittedFrame.midY)
                        .clipped()
                    }
                    .scaleEffect(currentScale)
                    .rotationEffect(currentAngle)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .gesture(simultaneousGestures())
                    
                    VStack {
                        Picker("Tool panel", selection: $currentToolPanel) {
                            ForEach(ToolPanelType.allCases, id: \.self) { toolPanelType in
                                Text(toolPanelType.rawValue)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal)
                        .padding(.top, 6)
                        .background(.ultraThinMaterial)
                        
                        Spacer()
                        
                        if currentToolPanel == .filters {
                            filtersPanel
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    let renderedImage = Image(uiImage: getRenderedImage())
                    
                    ShareLink(
                        item: renderedImage,
                        subject: Text("Drawing"),
                        message: Text("Drawn with MyApp!"),
                        preview: SharePreview("Drawing", image: renderedImage)
                    ) {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                    .onTapGesture {
                        currentToolPanel = .hidePanel
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button("Erase all drawing", systemImage: "eraser.line.dashed.fill") {
                            drawing = PKDrawing()
                        }
                        
                        Button("Set default frame", systemImage: "photo.artframe") {
                            currentAngle = .zero
                            currentScale = 1.0
                        }
                        
                        Button("Choose another photo", systemImage: "icloud.and.arrow.up") {
                            showWarningAlert = true
                        }
                        
                        Button("Save Drawing", systemImage: "arrow.down.doc") {
                            saveImageToPhotoLibrary()
                        }
                        
                        Button("Sign out", systemImage: "house.fill") {
                            signOut()
                        }
                        
                    } label: {
                        Label("Actions", systemImage: "ellipsis.circle")
                    }
                }
            }
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .alert("Warning!", isPresented: $showWarningAlert) {
                Button("Contintue editing", role: .cancel) {
                    
                }
                
                Button("Discard changes", role: .destructive) {
                    currentToolPanel = .hidePanel
                    appCoordinator.setRoot(.uploadYourPhoto)
                }
            } message: {
                Text("Current changes will not be saved")
            }
            .alert("No access to the gallery", isPresented: $showAlertGoToSettings) {
                Button("Settings") {
                    if let settingsURL = URL(string: UIApplication.openSettingsURLString),
                       UIApplication.shared.canOpenURL(settingsURL) {
                        UIApplication.shared.open(settingsURL)
                        saveImage()
                    }
                }
                
                Button("Cancel") { }
            } message: {
                Text("Please provide access in settings")
            }
        }
        .onDisappear {
            saveImage()
        }
    }
}

private extension EditingPhotoScreen {
    
    @ViewBuilder
    var filtersPanel: some View {
        Picker("Filters", selection: $currentFilter) {
            ForEach(FilterType.allCases, id: \.self) { filter in
                Text(filter.nameForUser)
            }
        }
        .pickerStyle(.segmented)
        .onChange(of: currentFilter) {
            setFilter()
        }
        .padding(.top)
        .padding(.horizontal)
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
    }
    
    func saveImage() {
        viewModel.saveImage(getRenderedImage())
    }
    
    func setFilter() {
        uiImage = createNewImageWithFilter(originalUIImage, filter: currentFilter)
    }
    
    func setOriginalImage() {
        uiImage = originalUIImage
    }
    
    func signOut() {
        viewModel.signOut {
            appCoordinator.setRoot(.auth)
        } errorMessage: { message in
            appCoordinator.showAlert(title: "Error sign out", message: message)
        }
    }
    
    func simultaneousGestures() -> some Gesture {
        SimultaneousGesture(
            MagnificationGesture().onChanged { scale in
                currentScale = scale
            },
            RotationGesture().onChanged { angle in
                currentAngle = angle
            }
        )
    }
    
    func getRenderedImage() -> UIImage {
        let canvasSize = canvasView.bounds.size
        
        let format = UIGraphicsImageRendererFormat()
        format.scale = UIScreen.main.scale
        format.opaque = false
        
        let renderer = UIGraphicsImageRenderer(size: canvasSize, format: format)
        
        let renderedImage = renderer.image { _ in
            uiImage.draw(in: CGRect(origin: .zero, size: canvasSize))
            
            let drawingImage = drawing.image(from: canvasView.bounds, scale: UIScreen.main.scale)
            drawingImage.draw(in: CGRect(origin: .zero, size: canvasSize))
        }
        
        return renderedImage
    }
    
    func saveImageToPhotoLibrary() {
        UIImageWriteToSavedPhotosAlbum(getRenderedImage(), nil, nil, nil)
        
        viewModel.checkPhotoLibraryPermission { isAuthorized in
            if isAuthorized {
                appCoordinator.showAlert(title: "Saved to gallery", message: "Check your gallery")
            } else {
                showAlertGoToSettings = true
            }
        }
    }
}

#Preview {
    RootView()
}
