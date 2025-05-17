//
//  SignInScreen.swift
//  Editing Photo
//
//  Created by mac on 16.05.25.
//

import SwiftUI

struct AuthScreen: View {
    
    @ObservedObject private var viewModel: AuthViewModel

    init(viewModel: AuthViewModel = .init()) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            Color.background
            
            ScrollView {
                
                VStack {
                    
                    VStack(spacing: 25) {
                        switch viewModel.enterType {
                            case .signIn: signInTextFields
                            case .signUp: signUpTextFields
                        }
                        
                        Button(viewModel.enterType.name) {
                            viewModel.buttonEnterTapped()
                        }
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
                    .padding(.top, 25)
                    
                    Spacer()
                    
                    HStack(alignment: .center) {
                        Text(viewModel.enterType.tip)
                        
                        Button(viewModel.enterType.name) {
                            viewModel.toggleEnterMode()
                        }
                        .font(.system(size: 14, weight: .medium))
                    }
                    .padding(.top, 25)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 25)
            }
            .navigationTitle(viewModel.enterType.title)
        }
    }
    
    var forgetPasswordButton: some View {
        HStack {
            Spacer()
            
            Button("Forgot Password?") {
                
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

#Preview {
    RootView()
}
