//
//  MainScreenViewModel.swift
//  Editing Photo
//
//  Created by mac on 17.05.25.
//

import FirebaseAuth
import SwiftUI

final class MainScreenViewModel: ObservableObject {
    
    func signOut() {
        do {
          try Auth.auth().signOut()
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
    func sendEmailVerification(onSuccess: @escaping ()->(), errorMessage: @escaping (String)->()) {
        guard let user = Auth.auth().currentUser else {
            errorMessage("Пользователь не авторизован")
            return
        }

        user.sendEmailVerification { error in
            if let error {
                errorMessage(error.localizedDescription)
                return
            }
            
            onSuccess()
        }
    }
}
