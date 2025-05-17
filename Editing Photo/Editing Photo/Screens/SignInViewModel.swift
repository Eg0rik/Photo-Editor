//
//  SignInViewModel.swift
//  Editing Photo
//
//  Created by mac on 16.05.25.
//

import SwiftUI
import Combine

final class SignInViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var emailErrorMessage: String? = nil
    private let emailValidator = EmailValidator()
    
    @Published var password: String = ""
    @Published var passwordErrorMessage: String? = nil
    private let passwordValidator = PasswordValidator()
    
    @Published var isButtonEnabled = false
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        setupSubscriptions()
    }
    
    func signIn() {
        guard isButtonEnabled else { return }
        
        
    }
}

private extension SignInViewModel {
    func setupSubscriptions() {
        setupEmailValidationSubscription()
        setupPasswordValidationSubscription()
    }
    
    func setupEmailValidationSubscription() {
        $email
            .dropFirst()
            .sink { [weak self] email in
                guard let self else { return }
                
                emailErrorMessage = emailValidator.validate(email) ?? ""
                validateAll()
            }
            .store(in: &subscriptions)
    }
    
    func setupPasswordValidationSubscription() {
        $password
            .dropFirst()
            .sink { [weak self] password in
                guard let self else { return }
                
                passwordErrorMessage = passwordValidator.validate(password) ?? ""
                validateAll()
            }
            .store(in: &subscriptions)
    }
    
    func validateAll() {
        guard let passwordErrorMessage, let emailErrorMessage else  { return }
        
        isButtonEnabled = passwordErrorMessage.isEmpty && emailErrorMessage.isEmpty
    }
}

#Preview {
    SignInScreen()
}
