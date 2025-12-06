//
//  LoginRepositoryProtocol.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 12/11/25.
//

import Foundation

protocol LoginRepositoryProtocol {
    
    
    func registerUser(_ request: RegisterUserRequest) async throws -> RegisterUserResponse
    
    
}
