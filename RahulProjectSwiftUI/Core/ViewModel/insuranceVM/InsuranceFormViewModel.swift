//
//  InsuranceFormViewModel.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 26/12/25.
//

import Foundation

@MainActor
class InsuranceFormViewModel : ObservableObject {
    
    private let repository : InsuranceRepositoryProtocol
    let category: InsuranceType
    

    
    @Published private(set) var state: ViewState<Void> = .idle
    
    init(repository: InsuranceRepositoryProtocol, category: InsuranceType) {
        
        self.repository = repository
        self.category = category
    }
    
    func save (provider: String, number: String) async {
        
        
        state = .loading
        
        do {
            
            
            try await Task.sleep(nanoseconds: 300_000_000)

            try await repository.addPolicy(
                type: category,
                provider: provider,
                number: number
            )
            
            state = .success(())
        }
        catch {
            state = .error(.unknown(error.localizedDescription))
        }
    }
    
    
}
