//
//  EditingPhotoScreenViewModel.swift
//  Editing Photo
//
//  Created by mac on 19.05.25.
//

import SwiftUI
import FirebaseAuth

final class EditingPhotoViewModel: ObservableObject {
    func signOut(onSuccess: @escaping ()->(), errorMessage: @escaping (String)->()) {
        do {
            try Auth.auth().signOut()
            onSuccess()
        } catch let signOutError as NSError {
            errorMessage("\(signOutError)")
        }
    }
}
