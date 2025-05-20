//
//  UploadYourPhotoScreen.swift
//  Editing Photo
//
//  Created by mac on 19.05.25.
//

import SwiftUI
import PhotosUI

struct UploadYourPhotoScreen: View {
    
    @EnvironmentObject var appCoordinator: AppCoordinator
    @StateObject private var viewModel = UploadYourPhotoScreenViewModel()
    
    var body: some View {
        VStack {
            PhotosPicker(selection: $viewModel.imageSelection, matching: .images) {
                VStack(spacing: 90) {
                    Image(systemName: "icloud.and.arrow.up")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120, height: 94)
                        .foregroundStyle(Color.text)
                    
                    Text("Upload Your Photo")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(Color.text)
                }
            }
            .onChange(of: viewModel.uiImage) {
                if let uiImage = viewModel.uiImage {
                    appCoordinator.setRoot(.editingPhoto(uiImage))
                }
            }
        }
    }
}

#Preview {
    UploadYourPhotoScreen()
}
