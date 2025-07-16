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
        return HomeViewModel(homeRepository: makeHomeRepository())
    }
    
    @MainActor func makeAuthViewModel() -> AuthViewModel {
        return AuthViewModel(userRepository: userRepository)
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
