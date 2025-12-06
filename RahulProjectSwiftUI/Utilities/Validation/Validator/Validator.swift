//
//  Validator.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 13/11/25.
//

import Foundation

struct Validator {
    
    static func validateName(_ name: String) -> ValidationError? {
        name.trimmingCharacters(in: .whitespaces).isEmpty
        ? .emptyField(field: "Full name")
        : nil
    }
    
    static func validateEmail(_ email: String) -> ValidationError? {
        email.isEmpty ? .emptyField(field: "Email")
        : ValidationRules.isValidEmail(email) ? nil : .invalidEmail
    }
    
    static func validatePhone(_ phone: String) -> ValidationError? {
        phone.isEmpty ? .emptyField(field: "Mobile")
        : ValidationRules.isValidPhone(phone) ? nil : .invalidPhone
    }
    
    static func validateDOB(_ dob: String) -> ValidationError? {
        dob.isEmpty ? .emptyField(field: "Date of Birth")
        : ValidationRules.isValidDOB(dob) ? nil : .invalidDate
        
    }
    
    static func validatePincode(_ pincode: String) -> ValidationError? {
        pincode.isEmpty
        ? .emptyField(field: "Pincode")
        : ValidationRules.isValidPincode(pincode) ? nil : .invalidPincode
    }
    
   
    static func validateState(_ state: String?) -> ValidationError? {
        guard let state = state, !state.isEmpty else {
            return ValidationError.custom(message: "Please select a state")
        }
        return nil
    }
    
    static func validateRequired(_ value: String, field: String) -> ValidationError? {
        value.trimmingCharacters(in: .whitespaces).isEmpty
        ? .emptyField(field: field)
        : nil
    }
    
}
