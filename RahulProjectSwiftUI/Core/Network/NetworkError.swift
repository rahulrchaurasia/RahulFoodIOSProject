//
//  NetworkError.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 01/04/25.
//

import Foundation

// Network Errors
enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidRequest
    case invalidResponse
    case unauthorized
    case badRequest(String?)
    case serverError(Int, Data?)
    case networkUnavailable        // No internet
    case serverUnreachable         // DNS/Host issues
    
    case unknown(String?)
    case networkError(Error)
    case decodingError(Error)
    case noData
    case cancelled
    case timeout
    
    // Domain errors
       case userNotFound
    
    var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "Invalid URL. Please check the API endpoint."
            case .invalidRequest:
                return "Invalid request parameters."
            case .invalidResponse:
                return "Invalid response from server."
            case .unauthorized:
                return "Unauthorized access. Please login again."
            case .badRequest(let message):
                return message ?? "Bad request."
            case .serverError(let code, let data):
                if let data = data,
                   let errorMsg = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                    return "Server error (\(code)): \(errorMsg.message)"
                }
                return "Server error with status code: \(code)"
            case .networkUnavailable:
                return "No internet connection. Please check your network."
            case .serverUnreachable:
                return "Server is unreachable. Please try again later."
                
            case .unknown(let msg):
                        return msg ?? "An unknown error occurred."
                
            case .networkError(let error):
                return "Network error: \(error.localizedDescription)"
            case .decodingError(let error):
                return "Failed to decode response: \(error.localizedDescription)"
            case .noData:
                return "No data received from server."
            case .cancelled:
                return "Request cancelled."
            case .timeout:
                return "Request timed out. Please try again."
            case .userNotFound:
                return "The email or password you entered is incorrect."
            }
        }
}

// Error Response Model
struct ErrorResponse: Decodable {
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case message = "Message"
    }
}

extension NetworkError: Equatable {
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        // Implementation of equality comparison for NetworkError
        // This is simplified - you'll need to compare all cases properly
        String(describing: lhs) == String(describing: rhs)
    }
}
