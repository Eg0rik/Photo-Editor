//
//  Functions.swift
//  Editing Photo
//
//  Created by mac on 19.05.25.
//

import Foundation
import FirebaseAuth

func getAuthErrorMessage(_ error: NSError) -> String {
    guard let code = AuthErrorCode(rawValue: error.code) else {
        return error.localizedDescription
    }
    
    switch code {
        case .invalidEmail:
            return "Invalid email address."
        case .wrongPassword:
            return "Wrong password. Try again."
        case .userNotFound:
            return "No user found with this email."
        case .userDisabled:
            return "This user account has been disabled."
        case .tooManyRequests:
            return "Too many login attempts. Try again later."
        case .networkError:
            return "Network error. Check your internet connection."
        default:
            return error.localizedDescription
    }
}
