//
//  LoginFormValidator.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 04/04/25.
//

import Foundation

/*
 Since LoginField conforms to RawRepresentable with a String raw value, each case has a string you can access:

 LoginField.email.rawValue == "email"

 LoginField.password.rawValue == "password"


 */

// Login form fields
enum LoginField: Int, FormField, CaseIterable {
//    case email
//    case password
//    case address
//    
//    var id: String { rawValue }
    
       case email = 0
       case password = 1  // Keep the original name for compatibility
       case address = 2
       
       var id: String { rawValue.description }
}


// Login form validator
/*
 "Inside this class, when the FormValidator protocol refers to a generic Field, we are saying that Field is actually LoginField."

 So yes — Field becomes an alias for LoginField, just like:
 Field == LoginField

 
 protocol FormValidator {
     associatedtype Field: FormField
     func validate() -> ValidationResult<Field>
 }
 Then each form validator (e.g. LoginFormValidator) specifies what its Field type is.


 */
class LoginFormValidator: FormValidator {
    typealias Field = LoginField
    
    private var email: String
    private var password: String
    private var address: String
    
    init(email: String = "", password: String = "", address: String = "") {
        self.email = email
        self.password = password
        self.address = address
    }
    
    func validate() -> ValidationResult<LoginField> {
        return LoginFormValidator.validate(email: email, password: password, address: address)
    }
    
    // Truly sequential validation - only check the next field if the previous one is valid
    static func validate(email: String, password: String, address: String) -> ValidationResult<LoginField> {
        var errors = [LoginField: String]()
        
        // Step 1: Validate email first
        if email.isEmpty {
            errors[.email] = "Please enter email"
            return ValidationResult(
                isValid: false,
                errors: errors,
                firstErrorField: .email
            )
        } else if !isValidEmail(email) {
            errors[.email] = "Please enter a valid email"
            return ValidationResult(
                isValid: false,
                errors: errors,
                firstErrorField: .email
            )
        }
        
        // Email is valid, now validate address
        if address.isEmpty {
            errors[.address] = "Please enter address"
            return ValidationResult(
                isValid: false,
                errors: errors,
                firstErrorField: .address
            )
        }
        
        // Address is valid, now validate password
        if password.isEmpty {
            errors[.password] = "Please enter password"
            return ValidationResult(
                isValid: false,
                errors: errors,
                firstErrorField: .password
            )
        } else if password.count < 3 {
            errors[.password] = "Password is too short..."
            return ValidationResult(
                isValid: false,
                errors: errors,
                firstErrorField: .password
            )
        }
        
        // All validations passed
        return ValidationResult(
            isValid: true,
            errors: [:],
            firstErrorField: nil
        )
    }
    
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
