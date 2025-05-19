//
//  ForgetPasswordScreen.swift
//  Editing Photo
//
//  Created by mac on 18.05.25.
//

import SwiftUI
import Combine
import FirebaseAuth

final class ForgetPasswordScreenViewModel: ObservableObject {
    
    @Published var isButtonEnabled = false
    
    @Published var email: String = ""
    @Published var emailErrorMessage: String? = nil
    private let emailValidator = EmailValidator()
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        setupEmailValidationSubscription()
    }
    
    ///To reset password.
    func sendPasswordReset(onSuccess: @escaping ()->(), errorMessage: @escaping (String)->()) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error {
                errorMessage(error.localizedDescription)
                return
            }
            
            onSuccess()
        }
    }
}

private extension ForgetPasswordScreenViewModel {
    func setupEmailValidationSubscription() {
        $email
            .sink { [weak self] email in
                guard let self else { return }
                
                if email.isEmpty {
                    emailErrorMessage = nil
                    
                } else {
                    emailErrorMessage = emailValidator.validate(email) ?? ""
                }
                
                checkIsButtonEnabled()
            }
            .store(in: &subscriptions)
    }
    
    func checkIsButtonEnabled() {
        guard let emailErrorMessage else {
            isButtonEnabled = false
            return
        }
        
        isButtonEnabled = emailErrorMessage == ""
    }
}
