//
//  HomeRepository.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 08/04/25.
//

import Foundation

actor HomeRepository : HomeRepositoryProtocol {
   
    //static let shared = HomeRepository()

    
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
  
    func getFoodDetails() async throws -> DishCategoryResponse? {
      
       // let headers = ["token": Configuration.token]
        
        let customBaseURL = "https://yummie.glitch.me/dish-categories"
        let response : DishCategoryResponse = try await
        
        apiService.requestSimple(
            endpoint: "",
            method: .get,
            urlType: .custom(customBaseURL)
         
        )
        

        // Option 2: Provide all required parameters
                /*
                let customBaseURL = "https://yummie.glitch.me/dish-categories"
                return try await apiService.request(
                    endpoint: "",
                    method: .get,
                    urlType: .custom(customBaseURL),
                    headers: nil,
                    body: nil,
                    queryItems: nil
                )
                */
                
                // Option 3: Use external API request
                /*
                return try await apiService.requestExternalAPI(
                    url: "https://yummie.glitch.me/dish-categories",
                    method: .get,
                    headers: nil,
                    body: nil,
                    queryItems: nil
                )
                */
        return response
        
    }
    
    
    
    
}

