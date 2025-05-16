//
//  SignInScreen.swift
//  Editing Photo
//
//  Created by mac on 16.05.25.
//

import SwiftUI

struct SignInScreen: View {
    
    @State var email = ""
    @State var password = ""
    
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
                
                VStack(spacing: 40) {
                    TextField("Email", text: $email)
                        .textFieldStyle(UnderlineTextFieldStyle(text: "Email", icon: Image("user")))
                        .previewLayout(.sizeThatFits)
                    
                    VStack {
                        
                        SecureTextFieldWithToggle(placeholder: "Password", passwordText: $password)
                            .previewLayout(.sizeThatFits)
                        
                        HStack {
                            Spacer()
                            
                            Button("Forgot Password?") {
                                
                            }
                            .foregroundStyle(.white)
                            .font(.system(size: 14))
                        }
                        .padding(.top, 20)
                    }
                    
                    Button("Sign In") {
                        
                    }
                    .buttonStyle(BigButtonStyle())
                }
                .padding(.top, 89)
                
                Spacer()
                
                VStack {
                    HStack(spacing: 9) {
                        Rectangle()
                            .foregroundStyle(.ravenBlack)
                            .frame(height: 1)
                        
                        Text("Or")
                        
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
        }
    }
}

#Preview {
    SignInScreen()
}
