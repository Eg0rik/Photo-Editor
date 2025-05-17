//
//  SecureTextFieldWithToggle.swift
//  Editing Photo
//
//  Created by mac on 16.05.25.
//

import SwiftUI

struct SecureTextFieldWithToggle: View {
    let placeholder: String
    @Binding var passwordText: String
    @State var showPassword: Bool = false
    
    var body: some View {
        HStack {
            Group {
                if showPassword {
                    TextField(placeholder, text: $passwordText)
                } else {
                    SecureField(placeholder, text: $passwordText)
                }
            }
            .textFieldStyle(
                UnderlineTextFieldStyle(
                    text: placeholder,
                    leftView: AnyView(buttonToggle)
                )
            )
        }
    }
    
    var buttonToggle: some View {
        Button {
            showPassword.toggle()
        } label: {
            Image(showPassword ? "eye-slash" : "eye")
                .foregroundColor(.ultimateGrey)
        }
    }
}

#Preview {
    AuthScreen()
}
