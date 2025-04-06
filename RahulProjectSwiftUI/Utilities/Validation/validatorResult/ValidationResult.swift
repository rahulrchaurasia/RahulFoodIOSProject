//
//  ValidationResult.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 04/04/25.
//

import Foundation
/*
 The reason we write ValidationResult<Field: Hashable> is because we’re using a dictionary:
 
 let errors: [Field: String]
 ✅ Why Field needs to be Hashable:
 In Swift, all dictionary keys ([Key: Value]) must conform to Hashable. That’s how Swift efficiently stores and retrieves data from the dictionary.
 */

// Protocol for form fields that can be validated
protocol FormField: Hashable {
    var id: String { get }
}

// Generic validation result that works with any form field type
struct ValidationResult<Field: FormField> {
    let isValid: Bool
    let errors: [Field: String]
    let firstErrorField: Field?
    
    static var valid: ValidationResult<Field> {
        return ValidationResult(isValid: true, errors: [:], firstErrorField: nil)
    }
}

// Base protocol for form validators
/*
//Mark : "associatedtype Field" means that any conforming type must tell us what Field is.

And Field must conform to the FormField protocol (i.e., be Hashable and have an id: String).
 */


protocol FormValidator {
    associatedtype Field: FormField
    
    func validate() -> ValidationResult<Field>
}
