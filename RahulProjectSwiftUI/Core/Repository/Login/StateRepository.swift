//
//  StateRepository.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 18/11/25.
//

import Foundation

protocol StateRepositoryProtocol {
    func fetchStateList() async throws -> [String]
}

struct StateRepository : StateRepositoryProtocol {
    
    
    func fetchStateList() async throws -> [String] {
        
        
        try await Task.sleep(nanoseconds: 3_000_000_000)  //2 se
        
        return [
            "Andhra Pradesh",
                    "Arunachal Pradesh",
                    "Assam",
                    "Bihar",
                    "Chhattisgarh",
                    "Goa",
                    "Gujarat",
                    "Haryana",
                    "Himachal Pradesh",
                    "Jharkhand",
                    "Karnataka",
                    "Kerala",
                    "Madhya Pradesh",
                    "Maharashtra",
                    "Manipur",
                    "Meghalaya",
                    "Mizoram",
                    "Nagaland",
                    "Odisha",
                    "Punjab",
                    "Rajasthan",
                    "Sikkim",
                    "Tamil Nadu",
                    "Telangana",
                    "Tripura",
                    "Uttar Pradesh",
                    "Uttarakhand",
                    "West Bengal"
                   
               ]
    }
    
    
    
}
