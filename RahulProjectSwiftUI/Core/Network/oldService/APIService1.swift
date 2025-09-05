//
//  APIService1.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 11/04/25.
//

import Foundation

//Using Singleton Way
actor APIService1 {

    // Singleton
    static let shared = APIService1()

    // Default environment
    var environment: APIEnvironment = .production

    // Session configuration
    private let session: URLSession

    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60 //previosly iot was 30 sec
        configuration.waitsForConnectivity = true
        self.session = URLSession(configuration: configuration)
    }

    // Generic API request method
    func request<T: Decodable>(
        endpoint: String = "",
        method: HTTPMethod = .get,
        urlType: URLType = .primary,
       // baseURLType: APIEnvironment.BaseURLType = .primary,
        headers: [String: String] = [:],
        body: Encodable? = nil,
        queryItems: [URLQueryItem]? = nil
    ) async throws -> T {

        // Determine full URL
        let fullURL: URL = try {
           
            // Use the selected URL type
            let base = urlType.getURL(for: environment)
            
            // Handle URL construction more safely
            guard var components = URLComponents(string: base) else {
                throw NetworkError.invalidURL
            }

            // Add the endpoint if it's not empty
            //Mark: This method automatically handles slashes between components, so you don’t get a double slash (//) even if:
            if !endpoint.isEmpty {
                components.path = (components.path as NSString).appendingPathComponent(endpoint)
            }
           
            // Add query items for GET
            if method == .get, let queryItems = queryItems {
                components.queryItems = queryItems
            }

            guard let url = components.url else {
                throw NetworkError.invalidURL
            }

            return url
        }()

        // Build request
        var request = URLRequest(url: fullURL)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // Add custom headers
        headers.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }

        // Add body if needed
        if let body = body {
            do {
                request.httpBody = try JSONEncoder().encode(body)
            } catch {
                throw NetworkError.invalidRequest
            }
        }

        // Make network call
        do {
            let (data, response) = try await session.data(for: request)

            guard !data.isEmpty else { throw NetworkError.noData }

            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.badRequest("Invalid response")
            }

            switch httpResponse.statusCode {
            case 200...299:
                do {
                    return try JSONDecoder().decode(T.self, from: data)
                } catch {
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

        } catch let urlError as URLError {
            switch urlError.code {
            case .timedOut:
                throw NetworkError.timeout
            case .cancelled:
                throw NetworkError.cancelled
            default:
                throw NetworkError.networkError(urlError)
            }
        } catch {
            throw NetworkError.networkError(error)
        }
    }
    
    // Convenient method for external APIs
        func requestExternalAPI<T: Decodable>(
            url: String,
            method: HTTPMethod = .get,
            headers: [String: String] = [:],
            body: Encodable? = nil,
            queryItems: [URLQueryItem]? = nil
        ) async throws -> T {
            return try await request(
                endpoint: url,
                method: method,
                headers: headers,
                body: body,
                queryItems: queryItems
            )
        }
}
