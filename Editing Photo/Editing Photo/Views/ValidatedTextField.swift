//
//  ValidatedTextField.swift
//  Editing Photo
//
//  Created by mac on 16.05.25.
//

import SwiftUI

struct ValidatedTextField: View {
    @Binding var text: String
    @Binding var errorMessage: String?
    
    var body: some View {
        VStack {
            TextField("Email", text: $text)
                .textFieldStyle(UnderlineTextFieldStyle(text: "Email", icon: Image("user")))
                .previewLayout(.sizeThatFits)
            
            HStack {
                Text(errorMessage ?? "")
                    .foregroundStyle(.red)
                    .opacity(opacity)
                    .frame(height: 10)
                    .animation(.easeInOut(duration: 0.2), value: errorMessage)
                
                Spacer()
            }
            .padding(.top, 5)
        }
    }
    
    var opacity: Double {
        switch errorMessage {
            case nil: 0
            case "": 0
            default: 1
        }
    }
}

#Preview {
    SignInScreen()
}
