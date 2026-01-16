//
//  InsuranceViewModel.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 18/12/25.
//

import Foundation

@MainActor
class InsuranceViewModel : ObservableObject {
 
    // Dependencies
    private let repository: InsuranceRepositoryProtocol
    let category: InsuranceType // Store which type this VM manages
    
    // MARK: - State
        // The single source of truth for your UI.
        // .idle, .loading, .success([Data]), or .error(Error)
    @Published private(set) var state: ViewState<[InsuranceEntity]> = .idle
    
     @Published  var policies: [InsuranceEntity] = []
    
      // UI trigger for the sheet
        @Published var showAddSheet: Bool = false
    
    private var fetchTask: Task<Void, Never>?
    
    init(repository : InsuranceRepositoryProtocol , category: InsuranceType){
        
        self.repository = repository
        self.category = category
        
    }
    
    
    func loadData() {
        state = .loading
        Task {
            do {
                let items = try await repository.fetchPolicies(for: category)
                state = .success(items)
            } catch {
                state = .error(.unknown(error.localizedDescription))
            }
        }
    }
    
    
//    func savePolicy(provider : String, number : String) async {
//        
//        
//        state = .loading
//
//            do {
//                try await Task.sleep(nanoseconds: 300_000_000)
//
//                try await repository.addPolicy(
//                    type: category,
//                    provider: provider,
//                    number: number
//                )
//
//                let updated = try await repository.fetchPolicies(for: category)
//                state = .success(updated)
//               
//
//            } catch {
//                state = .error(.unknown(error.localizedDescription))
//            }
//     
//    }
}
