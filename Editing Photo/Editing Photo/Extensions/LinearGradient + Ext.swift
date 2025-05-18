//
//  LinearGradient.swift
//  Editing Photo
//
//  Created by mac on 16.05.25.
//

import SwiftUI

extension LinearGradient {
    static var mainGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient.mainGradient,
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}
