//
//  EditingPhotoScreen.swift
//  Editing Photo
//
//  Created by mac on 19.05.25.
//

import SwiftUI
import PencilKit

struct EditingPhotoScreen: View {
    @EnvironmentObject var appCoordinator: AppCoordinator
    
    @State private var toolPickerVisible = true
    @State private var drawing = PKDrawing()
    @State private var canvasView = PKCanvasView()
    
    @State private var currentScale: CGFloat = 1.0
    @State private var currentAngle: Angle = .zero
    @State private var showWarningAlert: Bool = false
    
    private var uiImage: UIImage
    
    init(uiImage: UIImage) {
        self.uiImage = uiImage
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                let fittedFrame = fittedRect(for: uiImage.size, in: geometry.size)
                
                ZStack {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: fittedFrame.width, height: fittedFrame.height)
                        .position(x: fittedFrame.midX, y: fittedFrame.midY)
                    
                    CanvasView(
                        drawing: $drawing,
                        toolPickerVisible: $toolPickerVisible,
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
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button("\(toolPickerVisible ? "Hide" : "Show") Tool Picker", systemImage: "wrench.adjustable") {
                            toolPickerVisible.toggle()
                        }
                        
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
                            appCoordinator.showAlert(title: "Saved to gallery", message: "Check your gallery")
                        }
                        
                    } label: {
                        Label("Actions", systemImage: "ellipsis.circle")
                    }
                }
            }
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            .alert("Warning!", isPresented: $showWarningAlert) {
                Button("Contintue editing", role: .cancel) {
                    
                }
                
                Button("Delete photo", role: .destructive) {
                    toolPickerVisible = false
                    appCoordinator.setRoot(.uploadYourPhoto)
                }
            } message: {
                Text("Current photo will not be saved")
            }
        }
    }
}

private extension EditingPhotoScreen {
    func fittedRect(for imageSize: CGSize, in containerSize: CGSize) -> CGRect {
        let imageAspect = imageSize.width / imageSize.height
        let containerAspect = containerSize.width / containerSize.height
        
        var resultSize = CGSize.zero
        
        if imageAspect > containerAspect {
            // Image is wider
            resultSize.width = containerSize.width
            resultSize.height = containerSize.width / imageAspect
        } else {
            // Image is taller
            resultSize.height = containerSize.height
            resultSize.width = containerSize.height * imageAspect
        }
        
        let origin = CGPoint(
            x: (containerSize.width - resultSize.width) / 2,
            y: (containerSize.height - resultSize.height) / 2
        )
        
        return CGRect(origin: origin, size: resultSize)
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
    }
}

#Preview {
    RootView()
}
