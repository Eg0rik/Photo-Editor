//
//  SignInScreen.swift
//  Editing Photo
//
//  Created by mac on 16.05.25.
//

import SwiftUI
import UIKit

struct AuthScreen: View {
    
    @EnvironmentObject var appCoordinator: AppCoordinator
    @StateObject private var viewModel = AuthScreenViewModel()
    @State private var showAlert: Bool = false
    @State private var isLoading = false
    
    var body: some View {
        content()
    }
    
    func content() -> some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            ScrollView {
                
                VStack {
                    
                    VStack(spacing: 25) {
                        switch viewModel.enterType {
                            case .signIn: signInTextFields
                            case .signUp: signUpTextFields
                        }
                        
                        Button(viewModel.enterType.name, action: buttonEnterTapped)
                            .buttonStyle(
                                BigButtonStyle(
                                    background: viewModel.isButtonEnabled ? AnyShapeStyle(LinearGradient.mainGradient) : AnyShapeStyle(Color.gray)
                                )
                            )
                            .padding(.top, 6)
                    }
                    .padding(.top, 30)
                    
                    Spacer()
                    
                    VStack {
                        HStack(spacing: 9) {
                            Rectangle()
                                .foregroundStyle(.ravenBlack)
                                .frame(height: 1)
                            
                            Text("Or")
                                .foregroundStyle(.primary)
                            
                            Rectangle()
                                .foregroundStyle(.ravenBlack)
                                .frame(height: 1)
                        }
                        
                        Button {
                            signInWithGoogle()
                        } label: {
                            Image("google")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 36, height: 36)
                                .background(
                                    RoundedRectangle(cornerRadius: 13)
                                        .fill(Color.white)
                                        .frame(width: 46, height: 46)
                                )
                                .padding(.top, 25)
                        }
                    }
                    .padding(.top, 25)
                    
                    Spacer()
                    
                    HStack(alignment: .center) {
                        Text(viewModel.enterType.tip)
                        
                        Button(viewModel.enterType.anotherName, action: viewModel.toggleEnterMode)
                            .font(.system(size: 14, weight: .medium))
                    }
                    .padding(.top, 25)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 25)
            }
            //прячем клаву
            .onTapGesture {
                UIApplication.shared.hideKeyboard()
            }
            .navigationTitle(viewModel.enterType.title)
            .alert("Check your email and confrim your account", isPresented: $showAlert) {
                Button("Ok", role: .cancel) {
                    appCoordinator.setRoot(.uploadYourPhoto)
                }
            }
            
            if isLoading {
                CustomProgressView()
            }
        }
    }
    
    var forgetPasswordButton: some View {
        HStack {
            Spacer()
            
            Button("Forgot Password?") {
                appCoordinator.presentSheet(.forgetPassword)
            }
            .foregroundStyle(.text)
            .font(.system(size: 14))
        }
    }
    
    var signUpTextFields: some View {
        VStack(spacing: 25) {
            ValidatedTextField(name: "Name", text: $viewModel.name, errorMessage: $viewModel.nameErrorMessage)
            
            ValidatedTextField(name: "Email", text: $viewModel.email, errorMessage: $viewModel.emailErrorMessage)
            
            ValidatedSecureTextField(name:"Password", text: $viewModel.password, errorMessage: $viewModel.passwordErrorMessage)
            
            ValidatedSecureTextField(name:"Confirm password", text: $viewModel.confirmPassword, errorMessage: $viewModel.confirmPasswordErrorMessage)
        }
    }
    
    var signInTextFields: some View {
        VStack(spacing: 25) {
            ValidatedTextField(name: "Email", text: $viewModel.email, errorMessage: $viewModel.emailErrorMessage)
            
            VStack {
                
                ValidatedSecureTextField(name:"Password", text: $viewModel.password, errorMessage: $viewModel.passwordErrorMessage)
                
                forgetPasswordButton
            }
        }
    }
}

private extension AuthScreen {
    func buttonEnterTapped() {
        guard viewModel.isButtonEnabled else { return }
        
        switch viewModel.enterType {
            case .signIn: proccessSignIn()
            case .signUp: proccessSignUp()
        }
    }
    
    func signInWithGoogle() {
        viewModel.signInWithGoogle {
            appCoordinator.setRoot(.uploadYourPhoto)
        } errorMessage: { message in
            appCoordinator.showAlert(title: "Error sign in with Google", message: message)
        }
        
    }
    
    func proccessSignIn() {
        isLoading = true
        
        viewModel.signIn {
            isLoading = false
            appCoordinator.setRoot(.uploadYourPhoto)
        } errorMessage: { message in
            isLoading = false
            appCoordinator.showAlert(title: "Error sign in", message: message)
        }
    }
    
    func proccessSignUp() {
        isLoading = true
        
        viewModel.signUp {
            sendEmailVerification()
        } errorMessage: { message in
            isLoading = false
            appCoordinator.showAlert(title: "Error sign up", message: message)
        }
    }
    
    func sendEmailVerification() {
        viewModel.sendEmailVerification {
            isLoading = false
            showAlert = true
        } errorMessage: { message in
            isLoading = false
            appCoordinator.showAlert(title: "Error send email verification", message: message)
        }
    }
}

#Preview {
    RootView()
}
