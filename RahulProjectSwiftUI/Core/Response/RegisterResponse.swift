//
//  RegisterResponse.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 09/12/24.
//

import Foundation

// MARK: - RegisterResponse
struct RegisterResponse: Codable {
    let code: Int
    let type, message: String
}
