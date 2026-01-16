//
//  InsuranceRepositoryProtocol.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 18/12/25.
//

import Foundation
import CoreData

protocol InsuranceRepositoryProtocol {
 
    func fetchPolicies(for type: InsuranceType) async throws -> [InsuranceEntity]
    
    
    func addPolicy(type: InsuranceType, provider: String, number: String) async throws
}


