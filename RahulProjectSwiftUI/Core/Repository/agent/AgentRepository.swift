//
//  AgentRepository.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 06/01/26.
//

import Foundation


protocol AgentRepositoryProtocol {
    func syncAgents(uid: String) async throws
    
    func fetchUserConstants(fbaId: String, ssid: String) async throws -> UserConstantResponse?
}

actor AgentRepository : AgentRepositoryProtocol {
    
    
    private let apiService: APIServiceProtocol
        private let coreDataManager: CoreDataManager
    
    init(apiService: APIServiceProtocol, coreDataManager: CoreDataManager = .shared) {
            self.apiService = apiService
            self.coreDataManager = coreDataManager
        }
    
    func syncAgents(uid: String) async throws {
            let urlString = "http://3.111.3.129/qa-api/api/agents_listByEmp"
            
            let headers = ["token": "1234567890"]
        // ✅ Industrial Way: Type-safe, no spelling errors possible
                let requestBody = AgentSyncRequest(UId: uid)
            
        // 3. Fetch Data
                // The compiler now knows how to encode 'requestBody' because it is a struct
            let response: AgentListResponse? = try await apiService.request(
                endpoint: "",
                method: .get,
                urlType: .custom(urlString),
                headers: headers,
                body: requestBody,
                queryItems: nil
            )
            
            guard let agents = response?.masterData, !agents.isEmpty else { return }
            
            // 2. Save to Core Data (Background Thread)
            // We wrap this in a continuation to await the background write
//            await withCheckedContinuation { continuation in
//                
//                coreDataManager.performBackgroundTask { context in
//                    
//                    for dto in agents {
//                        // UPSERT LOGIC: Check if Agent exists by ID
//                        let request = AgentEntity.fetchRequest()
//                        request.predicate = NSPredicate(format: "agentId == %d", dto.agentId)
//                        request.fetchLimit = 1
//                        
//                        let entity: AgentEntity
//                        
//                        if let existing = try? context.fetch(request).first {
//                            entity = existing // Update existing
//                        } else {
//                            entity = AgentEntity(context: context) // Create new
//                            entity.agentId = Int64(dto.agentId)
//                        }
//                        
//                        // Map properties
//                        entity.fullName = dto.fullName
//                        entity.email = dto.email
//                        entity.mobile = dto.mobile
//                        entity.uid = dto.uid
//                    }
//                    
//                    // performBackgroundTask auto-saves here
//                    continuation.resume()
//                }
//            }
        }
    
    
    
    func fetchUserConstants(fbaId: String, ssid: String) async throws -> UserConstantResponse? {
        
        let urlString = "https://horizon.policyboss.com:5443/Postfm/user-constant-pb"
        // Use Struct for Body (Safety)
                let requestBody = UserConstantRequest(
                    appVersion: "policyboss-1.4.0.4",
                    deviceCode: "e73cb6c8dd4be83c",
                    fbaid: fbaId,
                    ssid: ssid
                )
        
        // Fetch & Decode
                let response: UserConstantResponse = try await apiService.request(
                    endpoint: "",
                    method: .post,
                    urlType: .custom(urlString),
                    headers: ["Content-Type": "application/json"],
                    body: requestBody,
                    queryItems: nil
                )
        
        // Return the inner data directly
                return response
    }
    
}
