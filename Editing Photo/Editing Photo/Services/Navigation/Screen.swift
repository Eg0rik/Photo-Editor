//
//  ContentLink.swift
//  Editing Photo
//
//  Created by mac on 17.05.25.
//

import SwiftUI

enum Screen: Identifiable, Hashable {
    case auth
    case forgetPassword
    case uploadYourPhoto
    case editingPhoto(UIImage)
    
    var id: UUID {
        UUID()
    }
}
