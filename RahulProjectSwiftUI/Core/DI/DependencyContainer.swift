//
//  DependencyContainer.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 14/04/25.
//

import Foundation


class DependencyContainer {
    
    let apiService: APIServiceProtocol
    let userRepository: UserRepositoryProtocol
    
    // This property will HOLD the single instance for the entire Home flow.
       private var sharedHomeViewModel: HomeViewModel?

    
    init(apiService: APIServiceProtocol? = nil) {
        
        // Initialize service
        self.apiService = apiService ?? APIService()
        
    
        self.userRepository = UserRepository(apiService: self.apiService)
        //self.orderRepository = OrderRepository(apiService: self.apiService)
        
        
         
      
    }
    
    
    
    // MARK: - Repository Factories
       func makeHomeRepository() -> HomeRepositoryProtocol {
           HomeRepository(apiService: apiService)
       }
    
    /****************** ViewModel Factories  *************************/
   
    // MARK: - ViewModel Factories
    @MainActor func makeHomeViewModel() -> HomeViewModel {
        print("⚠️ WARNING: Creating a NEW, non-shared HomeViewModel.")
        return HomeViewModel(homeRepository: makeHomeRepository())
    }
    
    @MainActor
    func makeSharedHomeViewModel() -> HomeViewModel {
            // If the shared instance already exists, just return it.
            if let existingViewModel = sharedHomeViewModel {
                print("✅ Returning EXISTING shared HomeViewModel instance.")
                return existingViewModel
            }
            
            // If it doesn't exist, this is the first time we're asking for it.
            print("✅ Creating a NEW shared HomeViewModel instance for the first time.")
            let newViewModel = HomeViewModel(homeRepository: makeHomeRepository())
            
            // IMPORTANT: Save the new instance so we can reuse it later.
            self.sharedHomeViewModel = newViewModel
            
            // Return the newly created instance.
            return newViewModel
        }
        
        // A method to clear the VM when the user logs out or leaves the flow.
        func clearHomeFlowDependencies() {
            self.sharedHomeViewModel = nil
        }
    
    @MainActor func makeAuthViewModel() -> AuthViewModel {
        return AuthViewModel(userRepository: userRepository)
    }
    
    // MARK: - Coordinator Factories
        @MainActor
        func makeAppCoordinator() -> AppCoordinatorProtocol {
            print("✅ Creating a REAL AppCoordinator for the live app.")
            return AppCoordinator()
        }
    
      // MARK: - View Factories
//    @MainActor
//        func makeHomeView() -> HomeView {
//            HomeView(
//                repository: makeHomeRepository()
//            )
//        }
//    
 
}
