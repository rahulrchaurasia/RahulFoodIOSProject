//
//  APIServiceProtocol.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 14/04/25.
//

import Foundation

/// Protocol for the API Service
protocol APIServiceProtocol {
    var environment: APIEnvironment { get set }
    
    func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        urlType: URLType,
        headers: [String: String]?,
        body: Encodable?,
        queryItems: [URLQueryItem]?
    ) async throws -> T
    
    func requestExternalAPI<T: Decodable>(
        url: String,
        method: HTTPMethod,
        headers: [String: String]?,
        body: Encodable?,
        queryItems: [URLQueryItem]?
    ) async throws -> T
}

// Add extension with convenience methods
extension APIServiceProtocol {
    // Convenience method with fewer required parameters
    //The requestSimple method is a "wrapper" around the full request method:
    
    /* Note : here we set default headers: nil,
    body: nil,
    queryItems: nil
     */
    
    func requestSimple<T: Decodable>(
        endpoint: String,
        method: HTTPMethod = .get,
        urlType: URLType = .primary
    ) async throws -> T {
        return try await request(
            endpoint: endpoint,
            method: method,
            urlType: urlType,
            headers: nil,
            body: nil,
            queryItems: nil
        )
    }
}
