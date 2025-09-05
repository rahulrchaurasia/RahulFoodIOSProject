//
//  APIService.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 01/04/25.
//

import Foundation



// MARK: - APIService
// MARK: - APIService

class APIService2: APIServiceProtocol {
    // Default environment
    var environment: APIEnvironment = .production
    
    // Session configuration
    private let session: URLSession
    
    init(sessionConfiguration: URLSessionConfiguration = .default) {
        let configuration = sessionConfiguration
        configuration.timeoutIntervalForRequest = 60
        configuration.waitsForConnectivity = true
        self.session = URLSession(configuration: configuration)
    }
    
    // Generic API request method
    func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        urlType: URLType,
        headers: [String: String]?,
        body: Encodable?,
        queryItems: [URLQueryItem]?
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
        if let headers = headers {
            headers.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        }

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
        method: HTTPMethod,
        headers: [String: String]?,
        body: Encodable?,
        queryItems: [URLQueryItem]?
    ) async throws -> T {
        return try await request(
            endpoint: url,
            method: method,
            urlType: .primary, // Use primary since we're passing full URL
            headers: headers,
            body: body,
            queryItems: queryItems
        )
    }
}
/*
 
 How to Use the Improved API Service

 1> Using Primary Base URL (default environment):

 swiftCopylet profile: UserProfile = try await APIService.shared.request(endpoint: "user/profile")

 
2> Using Secondary Base URL:

 swiftCopylet options: TravelOptions = try await APIService.shared.request(
     endpoint: "travel/options",
     baseURLType: .secondary
 )

 3> Using External API (completely different domain):

 swiftCopylet dishes: DishCategoryResponse = try await APIService.shared.requestExternalAPI(
     url: "https://yummie.glitch.me/dish-categories"
 )

 Using Custom Base URL (if reused frequently):

 swiftCopylet customBaseURL = "https://yummie.glitch.me"
 let dishes: DishCategoryResponse = try await APIService.shared.request(
     endpoint: "dish-categories",
      urlType: .custom(customBaseURL)
 )

 */
