//
//  RegisterUserRequest.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 12/11/25.
//

import Foundation


struct RegisterUserRequest : Encodable {
    
    let city: String
        let company: String
        let country: String
        let dob: String
        let email: String
        let fullname: String
        let gender: String
        let marital_status: String
        let mobile: String
        let occupation: String
        let pincode: String
        let state: String
        let street: String
}
