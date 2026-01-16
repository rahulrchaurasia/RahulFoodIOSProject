//
//  AgentViewModel.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 07/01/26.
//

import Foundation

@MainActor
final class AgentViewModel : ObservableObject {
    
    private let repository: AgentRepositoryProtocol
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showErrorAlert = false
    
    // ✅ Directly holding the API response struct
    @Published var data: UserConstantData?
    
    init(repository: AgentRepositoryProtocol) {
        self.repository = repository
    }
    
    func  fetchAgents() async  {
        isLoading = true
        errorMessage = nil
       
        do{
            // Hardcoded UID as per your request, usually passed in
            try await repository.syncAgents(uid: "119590")
            isLoading = false
            print("API Call success")
            
        }catch {
            isLoading = false
            errorMessage = error.localizedDescription
            print("API Call Failed")
        }
    }
    
    
    
    
    
    func fetchConstants() async {
        isLoading = true
        errorMessage = nil
        
        do {
            // Fetch the full response wrapper
          //  let response: UserConstantResponse = try await repository.fetchUserConstants(fbaId: "38846", ssid: "9707")
            let response : UserConstantResponse? =   try await repository.fetchUserConstants(fbaId: "121742", ssid: "150252")
            
            // Check the decoded object
            if let data = response?.masterData {
                // ✅ Success path
                self.data = data
                print("✅ Data Loaded")
            } else {
                // ❌ Failure path (The API returned 200 OK, but logic failed)
               // self.errorMessage = response?.message ?? "Unknown server error"
                
                self.handleError(response?.message ?? "Unknown server error")
                print("⚠️ Server Message: \(self.errorMessage ?? "")")
            }
            
        } catch {
            // ❌ Network/Decoding error
            self.errorMessage = error.localizedDescription
            showErrorAlert = true
            
        }
        
        isLoading = false
    }
    
    
    func handleError(_ message: String) {
           errorMessage = message
           showErrorAlert = true
       }
}
