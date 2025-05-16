//
//  BigButtonStyle.swift
//  Editing Photo
//
//  Created by mac on 16.05.25.
//

import SwiftUI

struct BigButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .bold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, maxHeight: 46)
            .background(LinearGradient.mainGradient)
            .cornerRadius(50)
    }
}

#Preview {
    SignInScreen()
}

