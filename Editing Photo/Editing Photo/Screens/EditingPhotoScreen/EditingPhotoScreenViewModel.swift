//
//  EditingPhotoScreenViewModel.swift
//  Editing Photo
//
//  Created by mac on 19.05.25.
//

import SwiftUI
import FirebaseAuth
import Photos

final class EditingPhotoViewModel: ObservableObject {
    func signOut(onSuccess: @escaping ()->(), errorMessage: @escaping (String)->()) {
        do {
            try Auth.auth().signOut()
            onSuccess()
        } catch let signOutError as NSError {
            errorMessage("\(signOutError)")
        }
    }
    
    func checkPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)

        switch status {
            case .authorized, .limited:
                completion(true)
            case .denied, .restricted:
                completion(false)
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization(for: .addOnly) { newStatus in
                    DispatchQueue.main.async {
                        completion(newStatus == .authorized || newStatus == .limited)
                    }
                }
            @unknown default:
                completion(false)
        }
    }
    
    func saveImage(_ uiImage: UIImage) {
        if let data = uiImage.pngData() {
            UserDefaults.standard.set(data, forKey: "savedImage")
        }
    }
}
