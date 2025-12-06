//
//  ValidationError.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 13/11/25.
//

import Foundation

enum ValidationError: LocalizedError, Equatable {
    case emptyField(field: String)
    case invalidEmail
    case invalidPhone
    case invalidDate
    case shortPassword
    case invalidPincode
    case custom(message: String)

    var errorDescription: String? {
        switch self {
        case .emptyField(let field):
            return "\(field) cannot be empty."
        case .invalidEmail:
            return "Please enter a valid email address."
        case .invalidPhone:
            return "Please enter a valid 10-digit mobile number."
        case .invalidDate:
            return "Please enter a valid date of birth."
        case .shortPassword:
            return "Password must be at least 6 characters long."
            
        case .invalidPincode :
             return "Please enter a valid 6 digit pincode."
        case .custom(let message):
            return message
        }
    }
}
