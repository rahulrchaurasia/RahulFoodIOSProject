//
//  UserRepositoryProtocol.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 01/04/25.
//

import Foundation

// MARK: - Features/User/Repositories/UserRepository.swift
protocol UserRepositoryProtocol {
    func getUserByEmail(_ email: String) async throws -> [User]
}
