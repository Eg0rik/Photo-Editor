//
//  Views.swift
//  Editing Photo
//
//  Created by mac on 16.05.25.
//

import SwiftUI

struct RoundedTextFieldStyle: TextFieldStyle {
    
    let icon: Image?
    let linearGradient: LinearGradient
    let text: String?
    
    init(
        text: String? = nil,
        icon: Image? = nil ,
        linearGradient: LinearGradient = .mainGradient
    ) {
        self.text = text
        self.linearGradient = linearGradient
        self.icon = icon
    }
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            if let text {
                Text(text)
                    .font(.system(size: 18))
                    .foregroundColor(.venusPink)
            }
            
            HStack {
                if icon != nil {
                    icon
                        .foregroundColor(.ultimateGrey)
                }
                
                configuration
                    .padding(.vertical, 12)
            }
            .overlay(
                VStack {
                    Spacer()
                    
                    linearGradient
                        .frame(height: 2)
                }
            )
        }
    }
}

#Preview {
    SignInScreen()
}
