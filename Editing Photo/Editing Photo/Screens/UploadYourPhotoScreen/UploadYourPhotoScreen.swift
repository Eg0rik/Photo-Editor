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
    @State private var showWarningAlert = false
    
    var body: some View {
        VStack {
            Spacer()
            
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
            
            Spacer()
            
            Button("Sign out", systemImage: "house.fill") {
                signOut()
            }
            .foregroundStyle(.red)
            .padding(.bottom, 20)
        }
    }
}

private extension UploadYourPhotoScreen {
    func signOut() {
        viewModel.signOut {
            appCoordinator.setRoot(.auth)
        } errorMessage: { message in
            appCoordinator.showAlert(title: "Error sign out", message: message)
        }
    }
}

#Preview {
    UploadYourPhotoScreen()
}
