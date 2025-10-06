//
//  CarRepository.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 03/10/25.
//

import Foundation


actor CarRepository  : CarRepositoryProtocol {
    
    // ✅ Dependency on your existing APIService protocol
        private let apiService: APIServiceProtocol

    // ✅ Initialize with an instance of your APIService
       
    
        init(apiService: APIServiceProtocol) {
            self.apiService = apiService
        }
    
    func fetchBanners() async throws -> [Banner] {
        
        let url = APIProvider.picsum + "list?limit=\(5)"
        let response =  try await apiService.request(
            endpoint: "",
            method: .get,
            urlType: .custom(url),
            headers: nil,
            body: nil,
            queryItems: nil
        ) as [PhotoResponse]
        
        // Map the response objects to your `Banner` model
        let banners = response.map { photo in
            Banner(id: photo.id,
                   title: photo.author, imageUrl: photo.download_url)
        }
        return banners
        
    }
    
    
    
    
}
