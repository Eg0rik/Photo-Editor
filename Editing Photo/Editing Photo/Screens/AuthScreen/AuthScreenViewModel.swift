//
//  SignInViewModel.swift
//  Editing Photo
//
//  Created by mac on 16.05.25.
//

import SwiftUI
import Combine
import FirebaseAuth
import FirebaseCore
import GoogleSignIn

final class AuthScreenViewModel: ObservableObject {
    
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var isButtonEnabled = false
    @Published private(set) var enterType = EnterType.signIn
    
    //----TextFields----
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
    //----TextFields----
    
    init() {
        setupEmailValidationSubscription()
        setupPasswordValidationSubscription()
    }
    
    func toggleEnterMode() {
        enterType == .signIn ? switchToSignUpMode() : switchToSignInMode()
    }
    
    func sendEmailVerification(onSuccess: @escaping ()->(), errorMessage: @escaping (String)->()) {
        guard let user = Auth.auth().currentUser else {
            errorMessage("User don't authrized")
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
    
    func signIn(success: @escaping ()->(), errorMessage: @escaping (String)->()) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
           
            print(result)
            print("====Sign In====")
            print(error)
            
            guard let error else {
                success()
                return
            }
            
            let nsError = error as NSError
            errorMessage(getAuthErrorMessage(nsError))
        }
    }
    
    func signUp(success: @escaping ()->(), errorMessage: @escaping (String)->()) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            
            print(result)
            print("====Sign Up====")
            print(error)
            
            guard let error else {
                success()
                return
            }
            
            let nsError = error as NSError
            errorMessage(getAuthErrorMessage(nsError))
        }
    }
    
    func signInWithGoogle(success: @escaping ()->(), errorMessage: @escaping (String)->()) {
        guard let rootViewController = UIViewController.rootViewController else {
            print("Unable to access root view controller")
            return
        }
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [unowned self] result, error in
            guard error == nil else {
                if let error = error as NSError? {
                    errorMessage(getAuthErrorMessage(error))
                }
                
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                errorMessage("Error with result from Google Sign-In")
                return
            }
            
            print(result)
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { result, error  in
                guard let error else {
                    success()
                    return
                }
                
                let nsError = error as NSError
                errorMessage(getAuthErrorMessage(nsError))
            }
        }
    }
}

private extension AuthScreenViewModel {
    
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

extension AuthScreenViewModel {
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
        
        var anotherName: String {
            switch self {
                case .signIn: "Sign Up"
                case .signUp: "Sign In"
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
