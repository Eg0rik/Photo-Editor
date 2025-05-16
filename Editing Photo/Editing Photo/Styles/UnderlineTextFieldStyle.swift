//
//  Views.swift
//  Editing Photo
//
//  Created by mac on 16.05.25.
//

import SwiftUI

struct UnderlineTextFieldStyle: TextFieldStyle {
    
    @Environment(\.colorScheme) var colorScheme
    
    let icon: Image?
    let linearGradient: LinearGradient
    let text: String?
    let leftView: AnyView?
    
    ///Shows `icon` or `leftView`.
    init(
        text: String? = nil,
        leftView: AnyView? = nil,
        icon: Image? = nil ,
        linearGradient: LinearGradient = .mainGradient
    ) {
        self.text = text
        self.linearGradient = linearGradient
        self.icon = icon
        self.leftView = leftView
    }
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            if let text {
                Text(text)
                    .font(.system(size: 18))
                    .foregroundColor(colorScheme == .dark ? .venusPink : .black)
            }
            
            HStack {
                Group {
                    if icon != nil {
                        icon
                            .foregroundColor(colorScheme == .dark ? .venusPink : .black)
                            .frame(width: 18, height: 18)
                    } else if let leftView {
                        leftView
                            .frame(width: 18, height: 18)
                    }
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
