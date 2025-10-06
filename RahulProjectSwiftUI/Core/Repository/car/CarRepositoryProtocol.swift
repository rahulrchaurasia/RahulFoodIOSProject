//
//  CarRepositoryProtocol.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 03/10/25.
//

import Foundation


protocol CarRepositoryProtocol {
   
    
    func fetchBanners() async throws -> [Banner]
    
    
}
