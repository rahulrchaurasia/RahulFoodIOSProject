//
//  APIEnvironment.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 01/04/25.
//

import Foundation

// MARK: - Network Layer

// Network Configuration
enum APIEnvironment {
    case development
    case staging
    case production
    
    var primaryBaseURL: String {
        switch self {
        case .development:
            return "http://inv.policyboss.com/travel-api/api/"
        case .staging:
            return "http://stage.policyboss.com/travel-api/api"
        case .production:
            return "http://zextratravelassist.interstellar.co.in/travel-api/api"
        }
    }
    
    var secondaryBaseURL: String {
        switch self {
        case .development:
            return "https://dev-horizon.policyboss.com:5443/posps/dsas"
        case .staging:
            return "https://stage-horizon.policyboss.com:5443/posps/dsas"
        case .production:
            return "https://horizon.policyboss.com:5443/posps/dsas"
        }
    }
}

// Simple URL type enum
enum URLType {
    case primary
    case secondary
    case custom(String)
    
    func getURL(for environment: APIEnvironment) -> String {
        switch self {
        case .primary:
            return environment.primaryBaseURL
        case .secondary:
            return environment.secondaryBaseURL
        case .custom(let url):
            return url
        }
    }
}


/*
 
 Usage Examples
 ✅ Use default environment + endpoint

 let result: MyResponse = try await APIService.shared.request(
     endpoint: "user/login",
     method: .post,
     body: LoginRequest(username: "test", password: "1234")
 )
 ✅ Use dynamic full URL

 let result: MyResponse = try await APIService.shared.request(
     endpoint: "https://horizon.policyboss.com:5443/Postfm/get-dynamic-app-pb",
     method: .get
 )
 ✅ Use secondary base URL with relative endpoint

 let result: MyResponse = try await APIService.shared.request(
     endpoint: "dynamic-data",
     baseURL: APIEnvironment.production.secondaryBaseURL
 )
 */


//Seperate URL for Diff URL
enum APIProvider {
    static let mealDBBaseURL = "https://www.themealdb.com/api/json/v1/1/"
    
    static let picsum = "https://picsum.photos/v2/"
}
