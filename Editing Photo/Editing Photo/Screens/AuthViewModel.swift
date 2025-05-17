//
//  SignInViewModel.swift
//  Editing Photo
//
//  Created by mac on 16.05.25.
//

import SwiftUI
import Combine

final class AuthViewModel: ObservableObject {
    var count = 0
    
    @Published var email: String = ""
    @Published var emailErrorMessage: String? = nil
    private let emailValidator = EmailValidator()
    
    @Published var name: String = ""
    @Published var nameErrorMessage: String? = nil
    private let nameValidator = NameValidator()
    
    @Published var password: String = ""
    @Published var passwordErrorMessage: String? = nil
    private let passwordValidator = PasswordValidator()
    
    @Published var confirmPassword: String = ""
    @Published var confirmPasswordErrorMessage: String? = nil
    
    @Published var isButtonEnabled = false
    @Published private(set) var enterType = EnterType.signIn
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        setupEmailValidationSubscription()
        setupPasswordValidationSubscription()
    }
    
    func buttonEnterTapped() {
        guard isButtonEnabled else { return }
        
        
    }
    
    func toggleEnterMode() {
        enterType == .signIn ? switchToSignUpMode() : switchToSignInMode()
    }
}

private extension AuthViewModel {
    func signIn() {
        
    }
    
    func signUp() {
        
    }
    
    func switchToSignInMode() {
        enterType = .signIn
        
        clearAllFields()
        
        setupEmailValidationSubscription()
        setupPasswordValidationSubscription()
    }
    
    func switchToSignUpMode() {
        enterType = .signUp
        
        clearAllFields()
        
        setupEmailValidationSubscription()
        setupPasswordValidationSubscription()
        setupConfirmPasswordValidationSubscription()
        setupNameValidationSubscription()
    }
    
    func setupEmailValidationSubscription() {
        $email
            .sink { [weak self] email in
                guard let self else { return }
                
                if email.isEmpty {
                    emailErrorMessage = nil
                    
                } else {
                    emailErrorMessage = emailValidator.validate(email) ?? ""
                }
                
                checkAllFields()
            }
            .store(in: &subscriptions)
    }
    
    func setupPasswordValidationSubscription() {
        $password
            .dropFirst()
            .sink { [weak self] password in
                guard let self else { return }
                
                if password.isEmpty {
                    passwordErrorMessage = nil
                } else {
                    passwordErrorMessage = passwordValidator.validate(password) ?? ""
                }
                
                validateConfirmaPassword()
                checkAllFields()
            }
            .store(in: &subscriptions)
    }
    
    func setupConfirmPasswordValidationSubscription() {
        $confirmPassword
            .dropFirst()
            .sink { [weak self] confirmPassword in
                guard let self else { return }
                
                validateConfirmaPassword()
                checkAllFields()
            }
            .store(in: &subscriptions)
    }
    
    func setupNameValidationSubscription() {
        $name
            .dropFirst()
            .sink { [weak self] name in
                guard let self else { return }
                
                if name.isEmpty {
                    nameErrorMessage = nil
                    
                } else {
                    nameErrorMessage = nameValidator.validate(name) ?? ""
                }
                
                checkAllFields()
            }
            .store(in: &subscriptions)
    }
    
    func checkAllFields() {
        switch enterType {
            case .signIn: checkAllForSignIn()
            case .signUp: checkAllForSignUp()
        }
    }
    
    func validateConfirmaPassword() {
        guard
            enterType == .signUp,
            !confirmPassword.isEmpty
        else {
            confirmPasswordErrorMessage = nil
            return
        }
        
        confirmPasswordErrorMessage = password == confirmPassword ? "" : "wrong password"
    }
    
    func checkAllForSignIn() {
        guard
            let passwordErrorMessage,
            let emailErrorMessage
        else  {
            isButtonEnabled = false
            return
        }
        
        isButtonEnabled = passwordErrorMessage.isEmpty && emailErrorMessage.isEmpty
    }
    
    func checkAllForSignUp() {
        guard
            let passwordErrorMessage,
            let emailErrorMessage,
            let confirmPasswordErrorMessage,
            let nameErrorMessage
        else  {
            isButtonEnabled = false
            return
        }
        
        
        
        isButtonEnabled = nameErrorMessage.isEmpty && passwordErrorMessage.isEmpty && confirmPasswordErrorMessage.isEmpty && emailErrorMessage.isEmpty
    }
    
    func clearAllFields() {
        subscriptions = []
        isButtonEnabled = false
        
        email = ""
        emailErrorMessage = nil
        
        name = ""
        nameErrorMessage = nil
        
        confirmPassword = ""
        confirmPasswordErrorMessage = nil
        
        password = ""
        passwordErrorMessage = nil
    }
}

extension AuthViewModel {
    enum EnterType {
        case signIn
        case signUp
        
        var title: String {
            switch self {
                case .signIn: "Welcome Back !"
                case .signUp: "Create Account"
            }
        }
        
        var name: String {
            switch self {
                case .signIn: "Sign In"
                case .signUp: "Sign Up"
            }
        }
        
        var tip: String {
            switch self {
                case .signIn: "Don't have an account?"
                case .signUp: "Go to"
            }
        }
        
        mutating func toggle() {
            switch self {
                case .signIn: self = .signUp
                case .signUp: self = .signIn
            }
        }
    }
}

#Preview {
    RootView()
}
