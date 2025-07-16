//
//  UserRepository.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 01/04/25.
//

import Foundation

actor UserRepository: UserRepositoryProtocol {
    private let apiService: APIServiceProtocol
    
//    init(apiService: APIService = APIService.shared) {
//        self.apiService = apiService
//    }
    
    // Remove the default parameter that references a singleton
        init(apiService: APIServiceProtocol) {
            self.apiService = apiService
            
            // self.authToken = tokenManager.currentToken  
        }

    
    func getUserByEmail(_ email: String) async throws -> [User] {
        let requestBody = UserEmailRequest(emailid: email)
        let headers = ["token": "1234567890"]
        
        let response: UserResponse = try await apiService.request(
            endpoint: "gettestUserByEmail",
            method: .post,
            urlType: .primary,
            headers: headers,
           
            body: requestBody,
            queryItems: nil
        )
        
        return response.masterData
    }
}

extension UserRepository {
   // static let shared = UserRepository(apiService: <#APIService#>)
    static let shared = UserRepository(apiService: APIService())
}
