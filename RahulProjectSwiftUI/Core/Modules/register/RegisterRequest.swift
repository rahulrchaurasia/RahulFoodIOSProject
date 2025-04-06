//
//  RegisterRequest.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 09/12/24.
//

//https://petstore.swagger.io/v2/user/{rahul55}
// MARK: - RegisterRequest
struct RegisterRequest: Codable {
    let id: Int
    let username, firstName, lastName, email: String
    let password, phone: String
    let userStatus: Int
}
