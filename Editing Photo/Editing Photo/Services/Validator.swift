//
//  Validator.swift
//  Editing Photo
//
//  Created by mac on 16.05.25.
//

import Foundation

protocol Validator {
    /// If text is valid return `nil` otherwise error message.
    func validate(_ text: String) -> String?
}

struct ValidatorErrorMessages {
    static let minLength = "Minimum length "
    static let maxLength = "Maximum length "
    static let minNumbers = "Minimum number of digits "
    static let maxNumbers = "Maximum number of digits "
    static let cyrillicOrLatinOnly = "Only Cyrillic or Latin characters allowed"
    static let validCharactersOnly = "Only letters are allowed"
    static let noConsecutiveSpecialCharacters = "No more than 2 special characters in a row"
    static let invalidEmailFormat = "Invalid email format"
    static let invalidPhoneNumber = "Invalid phone number format"
    static let invalidCharacters = "Invalid characters"
    static let createValidPasswordFirst = "Please create a valid password first"
    static let passwordsDoNotMatch = "Passwords don't match"
    static let containsNonNumericCharacters = "Only numbers are allowed"
}

final class EmailValidator: Validator {
    
    private let minLength = 5
    private let maxLength = 64
    
    func validate(_ text: String) -> String? {
        let emailRegex = "[A-Z0-9a-z ._%+-=^/`|?'{}!#$^&*()]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        guard emailTest.evaluate(with: text) else {
            return ValidatorErrorMessages.invalidEmailFormat
        }
        
        guard text.count <= maxLength else {
            return ValidatorErrorMessages.maxLength + "\(maxLength)"
        }
        
        return nil
    }
}

final class PasswordValidator: Validator {
    
    private let minLength = 6
    private let maxLength = 12
    
    func validate(_ text: String) -> String? {
        guard text.count >= minLength else {
            return ValidatorErrorMessages.minLength + "\(minLength)"
        }
        
        guard text.count <= maxLength else {
            return ValidatorErrorMessages.maxLength + "\(maxLength)"
        }
        
        return nil
    }
}

final class NameValidator: Validator {
    private let minLength = 2
    private let maxLength = 12
    
    func validate(_ text: String) -> String? {
        guard text.count >= minLength else {
            return ValidatorErrorMessages.minLength + "\(minLength)"
        }
        
        guard text.count <= maxLength else {
            return ValidatorErrorMessages.maxLength + "\(maxLength)"
        }
        
        let pattern = #"^[a-zA-Zа-яА-ЯёЁ]+$"#
        if text.range(of: pattern, options: .regularExpression) == nil {
            return ValidatorErrorMessages.validCharactersOnly
        }
        
        return nil
    }
}

