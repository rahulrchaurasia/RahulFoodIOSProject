//
//  HomeViewModel.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 08/04/25.
//

import Foundation
import SwiftUI

@MainActor
final class HomeViewModel: ObservableObject {
    
    // MARK: - Dependencies
    private let homeRepository: HomeRepositoryProtocol  //so it always expect homeRepository
    
    
    @Published var hasLoadedInitialData = false
    
    
// MARK: - Network State
    @Published private(set)  var state: ViewState<DishData> = .idle
    
        
    // Centralized alert state
    @Published var alertState = AlertState.hidden
    
    // MARK: - User Session
    @AppStorage("userEmail") private var storedEmail: String = ""
    
    
    // Removed default parameter to enforce proper DI
        init(homeRepository: HomeRepositoryProtocol) {
            self.homeRepository = homeRepository
        }
    
    func getFoodDetails() async {
        
        
        // Skip if already loaded data
        if hasLoadedInitialData { return }
     
        guard !state.isLoading else { return } // Mark :if state is loading true means its repeat call hence return
        
        state = .loading
        
        do {
            let dishResponse = try await homeRepository.getFoodDetails()
            
            print("URL: ",dishResponse ?? "" )
            if let dishResponse = dishResponse ,dishResponse.status == 200 {
                
                
                
                state = .success(dishResponse.data)
                alertState = .success(message: dishResponse.data.populars.first?.name ?? "")
                hasLoadedInitialData = true  // Set this flag when data loads successfully

            }
            else{
                state = .error(.noData)
                alertState = .error(message: Constant.noDataMSG)
            }
          
          
        } catch {
          
            handleError(error, for: \.state)
            print("ERROR in DishAPi",error.localizedDescription )
        }
    }
    
    // In HomeViewModel, modify the refreshFoodDetails method:
    func refreshFoodDetails() async {
        
        if hasLoadedInitialData { return }
        // Prevent multiple simultaneous refreshes
        guard !state.isLoading else { return }
        
        state = .loading
        
        do {
            // Use Task with a try-catch to handle cancellation
            try await Task {
                let dishResponse = try await homeRepository.getFoodDetails()
                
                if let dishResponse = dishResponse, dishResponse.status == 200 {
                    state = .success(dishResponse.data)
                } else {
                    state = .error(.noData)
                    alertState = .error(message: Constant.noDataMSG)
                }
            }.value
        } catch {
            // Handle cancellation separately from other errors
            if error is CancellationError {
                // Just reset to previous state if canceled
                if case .success = state {
                    // Keep the success state if we already had data
                } else {
                    state = .error(.cancelled)
                }
            } else {
                handleError(error, for: \.state)
                print("ERROR in DishAPi",error.localizedDescription )
            }
        }
    }
    
    // Explicit refresh function that bypasses the loading check
       func refreshFoodDetails2() async {
           state = .loading
           
           do {
               let dishResponse = try await homeRepository.getFoodDetails()
               
               if let dishResponse = dishResponse, dishResponse.status == 200 {
                   state = .success(dishResponse.data)
               } else {
                   state = .error(.noData)
                   alertState = .error(message: Constant.noDataMSG)
               }
           } catch {
               handleError(error, for: \.state)
               print("ERROR in DishAPi",error.localizedDescription )
           }
       }
    

  
    
    // MARK: - Error Handling
    private func handlefoodDishError(_ error: Error) {
        if let networkError = error as? NetworkError {
            state = .error(networkError)
            alertState = .error(message: networkError.errorDescription ?? "Unknown error")
        } else {
            state = .error(.networkError(error))
            alertState = .error(message: "Unexpected error: \(error.localizedDescription)")
        }
    }
    // MARK: - Centralized Error Handling
      private func handleError<T>(_ error: Error, for keyPath: ReferenceWritableKeyPath<HomeViewModel, ViewState<T>>) {
          if let networkError = error as? NetworkError {
              self[keyPath: keyPath] = .error(networkError)
              alertState = .error(message: networkError.errorDescription ?? "Unknown error")
          } else {
              self[keyPath: keyPath] = .error(.networkError(error))
              alertState = .error(message: "Unexpected error: \(error.localizedDescription)")
          }
      }
    
    // MARK: - Convenience Properties
    var isLoading: Bool {
        if case .loading = state {return true}
//        if case .loading = userState { return true }
//        if case .loading = otherDataState { return true }
        return false
    }
    var showError: Bool {
        get { alertState.isPresented }
        set {
            if !newValue {
                alertState = .hidden
            }
        }
    }
    
    var errorMessage: String {
        alertState.message
    }
    // *****End Convenience Properties here *****
    
}
