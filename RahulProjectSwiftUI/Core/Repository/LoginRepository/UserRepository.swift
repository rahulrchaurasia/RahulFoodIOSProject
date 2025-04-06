//
//  UserRepository.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 01/04/25.
//

import Foundation

actor UserRepository: UserRepositoryProtocol {
    private let apiService: APIService
    
    init(apiService: APIService = APIService.shared) {
        self.apiService = apiService
    }
    
    func getUserByEmail(_ email: String) async throws -> [User] {
        let requestBody = UserEmailRequest(emailid: email)
        let headers = ["token": "1234567890"]
        
        let response: UserResponse = try await apiService.request(
            endpoint: "gettestUserByEmail",
            method: .post,
            headers: headers,
           
            body: requestBody
        )
        
        return response.masterData
    }
}

extension UserRepository {
    static let shared = UserRepository()
}
