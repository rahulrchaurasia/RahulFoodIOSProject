//
//  LoginRepository.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 09/12/24.
//

import Foundation


class LoginRepository {
    
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
