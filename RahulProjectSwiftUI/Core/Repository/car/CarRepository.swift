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
    
    
    func fetchCarProposal() async throws -> [Proposal] {
        
        
        let headers = ["token": "1234567890"]
        // just for reference
//        let body: [String: String] = [
//            "startdate": "2024-01-01",
//            "enddate": "2026-11-30",
//            "empId": "",
//            "agentId": ""
//        ]
        
       // let requestBody = UserEmailRequest(emailid: email)
        let requestBody = ProposalRequest(empId: "", agentId: "", startdate: "2024-01-01", enddate: "2026-11-30")
        let response: CarResponse = try await apiService.request(
            endpoint: "getProposalMIS",
            method: .post,
            urlType: .primary,
            headers: headers,
            body: requestBody,
            queryItems: nil
        )
        
        return response.MasterData.proposals
       
    }
    
}
