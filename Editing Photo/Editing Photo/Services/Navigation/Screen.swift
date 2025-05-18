//
//  ContentLink.swift
//  Editing Photo
//
//  Created by mac on 17.05.25.
//

enum Screen: Identifiable {
    case auth
    case main
    case forgetPassword
    
    var id: Self {
        return self
    }
}
