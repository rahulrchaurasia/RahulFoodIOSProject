//
//  InsuranceRepository.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 18/12/25.
//

import Foundation
import CoreData


class InsuranceRepository : InsuranceRepositoryProtocol {
    
    // Dependencies
    private let apiService: APIServiceProtocol
    private let context: NSManagedObjectContext
  
    
    init(apiService: APIServiceProtocol, context: NSManagedObjectContext) {
            self.apiService = apiService
            self.context = context
        }
    
      
    func fetchPolicies(for type: InsuranceType) async throws -> [InsuranceEntity] {
        
        let request = NSFetchRequest<InsuranceEntity>(entityName: "InsuranceEntity")
        
        // ✅ Filter: Only get items where type == "Car" (or "Bike"/"Health")
        request.predicate = NSPredicate(format: "type == %@", type.rawValue)
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        
        // Use performAndWait if strictly synchronous, but for async await:
        
          return try await self.context.perform {
                try self.context.fetch(request)
            }
    }
    
    func addPolicy(type: InsuranceType, provider: String, number: String) async throws {
        
        try await context.perform {
            
            let item = InsuranceEntity(context: self.context)
            item.id = UUID()
            item.type = type.rawValue
            item.providerName = provider
            item.policyNumber = number
            item.timestamp = Date()
            
            try self.context.save() // ✅ THROW upward
            
            
           
            
        }
    }
    
   
    
    
}
