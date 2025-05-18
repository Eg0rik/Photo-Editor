//
//  BigButtonStyle.swift
//  Editing Photo
//
//  Created by mac on 16.05.25.
//

import SwiftUI

struct BigButtonStyle: ButtonStyle {
    
    let background: AnyShapeStyle
    
    init(background: some ShapeStyle = LinearGradient.mainGradient) {
        self.background = AnyShapeStyle(background)
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .bold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, minHeight: 46)
            .background(background)
            .cornerRadius(50)
    }
}

#Preview {
    RootView()
}

