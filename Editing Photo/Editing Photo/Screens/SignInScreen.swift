//
//  SignInScreen.swift
//  Editing Photo
//
//  Created by mac on 16.05.25.
//

import SwiftUI

struct SignInScreen: View {
    
    @ObservedObject private var viewModel: SignInViewModel
    
    init(viewModel: SignInViewModel = .init()) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            Color.background
            
            VStack {
                HStack {
                    Text("Welcome Back !")
                        .font(.system(size: 32, weight: .semibold))
                    
                    Spacer()
                }
                .padding(.top, 53)
                
                VStack(spacing: 25) {
                    ValidatedTextField(text: $viewModel.email, errorMessage: $viewModel.emailErrorMessage)
                    
                    
                    VStack {
                        
                        ValidatedSecureTextField(text: $viewModel.password, errorMessage: $viewModel.passwordErrorMessage)
                        
                        HStack {
                            Spacer()
                            
                            Button("Forgot Password?") {
                                
                            }
                            .foregroundStyle(.white)
                            .font(.system(size: 14))
                        }
                    }
                    
                    Button("Sign In") {
                        viewModel.signIn()
                    }
                    .buttonStyle(
                        BigButtonStyle(
                            background: viewModel.isButtonEnabled ? AnyShapeStyle(LinearGradient.mainGradient) : AnyShapeStyle(Color.gray)
                        )
                    )
                    
                    .padding(.top, 6)
                }
                .padding(.top, 89)
                
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
                        .padding(.top, 28.5)
                }
                
                Spacer()
                
                HStack(alignment: .center) {
                    Text("Don't have an account?")
                        
                    Button("Sign Up") {
                        
                    }
                    .font(.system(size: 14, weight: .medium))
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 25)
        }
    }
}

#Preview {
    SignInScreen()
}
