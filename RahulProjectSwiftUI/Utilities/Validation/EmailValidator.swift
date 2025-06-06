//
//  EmailValidator.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 25/12/24.
//

import Foundation


struct EmailValidator {
    static func isValid(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
