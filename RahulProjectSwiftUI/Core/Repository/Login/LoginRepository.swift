//
//  LoginRepository.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 09/12/24.
//

import Foundation


class LoginRepository : LoginRepositoryProtocol  {
    
    
    private let apiService : APIServiceProtocol
    
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
    func registerUser(_ request: RegisterUserRequest) async throws -> RegisterUserResponse {
        
        let endpoint = "testuserinsert"
        let headers = ["token": "1234567890"]
        
        let response: RegisterUserResponse = try await apiService.request(
                    endpoint: endpoint,
                    method: .post,
                    urlType: .primary,
                    headers: headers,
                    body: request,
                    queryItems: nil
                )
                return response
        
    }
    
  
    
    
    
    
    
    static func createUser(email: String, password: String) async throws {
            guard let url = URL(string: "https://reqres.in/api/register") else {
                throw URLError(.badURL)
            }
            
            let body = ["email": email, "password": password]
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(body)   //note: here JSONEncoder().encode requestBody
            
            let (data, _) = try await URLSession.shared.data(for: request)
            print("Response:", String(data: data, encoding: .utf8) ?? "")
        }
}
