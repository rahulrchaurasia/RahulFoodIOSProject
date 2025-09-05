//
//  APIService.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 19/04/25.
//

import Foundation


class APIService: APIServiceProtocol {
    // Environment configuration
    var environment: APIEnvironment = .production
    
    // Networking components
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    init(sessionConfiguration: URLSessionConfiguration = .default) {
        // Configure session
        let configuration = sessionConfiguration
        configuration.timeoutIntervalForRequest = 30
        configuration.waitsForConnectivity = true
        configuration.urlCache = URLCache.shared
        
        // Initialize components
        self.session = URLSession(configuration: configuration)
        self.decoder = JSONDecoder()
        self.encoder = JSONEncoder()
        
        // Configure decoder (optional date strategy)
       // decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
    }
    
    // Main request method
    func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod = .get,
        urlType: URLType = .primary,
        headers: [String: String]? = nil,
        body: Encodable? = nil,
        queryItems: [URLQueryItem]? = nil
    ) async throws -> T {
        // Build URL
        let url = try buildURL(endpoint: endpoint, urlType: urlType, queryItems: queryItems)
        
        // Create request
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Add headers
        headers?.forEach { request.addValue($1, forHTTPHeaderField: $0) }
        
        // Add body if needed
        if let body = body {
        
              request.httpBody = try encoder.encode(AnyEncodable(body))
        }
        
        // 🔍 Debug logging
              #if DEBUG
              print("➡️ Request: \(request.httpMethod ?? "") \(url.absoluteString)")
              if let body = request.httpBody,
                 let str = String(data: body, encoding: .utf8) {
                  print("📦 Body:", str)
              }
              #endif
        
        // Execute request
        do {
            let (data, response) = try await session.data(for: request)
            
            // 🔍 Debug response
                        #if DEBUG
                        if let httpResponse = response as? HTTPURLResponse {
                            print("⬅️ Response Code:", httpResponse.statusCode)
                        }
                        if let str = String(data: data, encoding: .utf8) {
                            print("⬅️ Response Body:", str)
                        }
                        #endif
            return try handleResponse(data: data, response: response)
        } catch {
            throw mapError(error)
        }
    }
    
    // External API convenience method
    func requestExternalAPI<T: Decodable>(
        url: String,
        method: HTTPMethod = .get,
        headers: [String: String]? = nil,
        body: Encodable? = nil,
        queryItems: [URLQueryItem]? = nil
    ) async throws -> T {
        return try await request(
            endpoint: url,
            method: method,
            urlType: .custom(url),
            headers: headers,
            body: body,
            queryItems: queryItems
        )
    }
    
    // MARK: - Private Methods
    
    private func buildURL(endpoint: String, urlType: URLType, queryItems: [URLQueryItem]?) throws -> URL {
        // Get base URL
        let base = urlType.getURL(for: environment)
        
        // Build URL components
        guard var components = URLComponents(string: base) else {
            throw NetworkError.invalidURL
        }
        
        // Add path component if needed
        if !endpoint.isEmpty {
            components.path = (components.path as NSString).appendingPathComponent(endpoint)
        }
        
        // Add query items if provided
        if let items = queryItems, !items.isEmpty {
            components.queryItems = items
        }
        
        // Create final URL
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        
        return url
    }
    
    private func handleResponse<T: Decodable>(data: Data, response: URLResponse) throws -> T {
        guard !data.isEmpty else { throw NetworkError.noData }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                print("Decoding error: \(error)")
                throw NetworkError.decodingError(error)
            }
        case 401:
            throw NetworkError.unauthorized
        case 400...499:
            throw NetworkError.badRequest(String(data: data, encoding: .utf8))
        case 500...599:
            throw NetworkError.serverError(httpResponse.statusCode, data)
        default:
            throw NetworkError.serverError(httpResponse.statusCode, data)
        }
    }
    
    private func mapError(_ error: Error) -> NetworkError {
            if let networkError = error as? NetworkError {
                return networkError
            }
            
            if let urlError = error as? URLError {
                switch urlError.code {
                case .timedOut:
                    return .timeout
                case .cancelled:
                    return .cancelled
                case .notConnectedToInternet:
                    return .networkUnavailable
                case .cannotFindHost, .cannotConnectToHost, .dnsLookupFailed:
                    return .serverUnreachable
                default:
                    return .networkError(urlError)
                }
            }
            
            return .networkError(error)
        }
}
