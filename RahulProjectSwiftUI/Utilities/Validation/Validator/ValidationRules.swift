//
//  ValidationRules.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 13/11/25.
//

import Foundation


struct ValidationRules {
    
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }

    static func isValidPhone(_ phone: String) -> Bool {
        let phoneRegex = "^[0-9]{10}$"
        return NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: phone)
    }

    static func isStrongPassword(_ password: String) -> Bool {
        return password.count >= 6
    }
    
    static func isValidDOB(_ dob: String) -> Bool {
           let regex = "^(0[1-9]|[12][0-9]|3[01])[- /.](0[1-9]|1[012])[- /.](19|20)\\d\\d$"
           return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: dob)
    }
    
    static func isValidPincode(_ pincode: String) -> Bool {
        let regex = "^[0-9]{6}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: pincode)
    }
}
