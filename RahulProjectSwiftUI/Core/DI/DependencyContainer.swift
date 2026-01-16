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
        let connectivityMonitor: ConnectivityMonitor
        
        // ✅ 1. Hold the CoreDataManager here
            let coreDataManager: CoreDataManager
       
        // Shared ViewModel state
        // This property will HOLD the single instance for the entire Home flow.
        private var sharedHomeViewModel: HomeViewModel?
        
        

        
    init(apiService: APIServiceProtocol? = nil,
         coreDataManager : CoreDataManager = .shared,
         connectivityMonitor: ConnectivityMonitor = NetworkConnectivityMonitor()
    ) {
            
            // Initialize service
            self.apiService = apiService ?? APIService()
            
        
            // ✅ 2. Initialize Core Data (Use passed instance or create new real one)
            self.coreDataManager = coreDataManager
            
            self.userRepository = UserRepository(apiService: self.apiService)
            //self.orderRepository = OrderRepository(apiService: self.apiService)
            
             self.connectivityMonitor = connectivityMonitor
          
        }
        
        
        
        // MARK: - Repository Factories
           func makeHomeRepository() -> HomeRepositoryProtocol {
               HomeRepository(apiService: apiService ,coreDataManager: coreDataManager )
           }
        
            // ✅ 1. ADD THE CAR REPOSITORY FACTORY
            func makeCarRepository() -> CarRepositoryProtocol {
                CarRepository(apiService: apiService)
            }

            func makeLoginRepository() -> LoginRepositoryProtocol {
                
                     LoginRepository(apiService: apiService)
            }
        
           
            func makeStateRepository() -> StateRepositoryProtocol {
            
                  StateRepository()
            }
            
        /****************** ViewModel Factories  *************************/
       
        // MARK: - ViewModel Factories
        @MainActor func makeHomeViewModel() -> HomeViewModel {
            print("⚠️ WARNING: Creating a NEW, non-shared HomeViewModel.")
            return HomeViewModel(homeRepository: makeHomeRepository())
        }
        
        // ✅ 2. ADD THE CAR VIEWMODEL FACTORY
        @MainActor func makeCarViewModel() -> CarViewModel {
            // This factory method correctly wires up the dependencies.
            CarViewModel(carRepository: makeCarRepository())
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
        
        
        @MainActor func makeLoginViewModel() -> LoginViewModel {
            return LoginViewModel(
            
                loginRepository : makeLoginRepository(),
            
                stateRepository: makeStateRepository()
            )
        }
        
        // MARK: - Coordinator Factories
            @MainActor
            func makeAppCoordinator() -> AppCoordinatorProtocol {
                print("✅ Creating a REAL AppCoordinator for the live app.")
                return AppCoordinator()
            }
        
  
        @MainActor func makePermissionHandler() -> PermissionHandler { PermissionHandler() }
        
        @MainActor  func makeProfileViewModel() -> ProfileViewModel {
            // This factory method correctly wires up the dependencies.
            return ProfileViewModel(
                
                permissionHandler: makePermissionHandler())
        }
        
     
    }


extension DependencyContainer {
    
    // 1. Factory for Repository
    
    func makeInsuranceRepository() -> InsuranceRepositoryProtocol {
            InsuranceRepository(
                apiService: apiService,
                context: coreDataManager.context
            )
        }

    
    
    // 2. Factory for ViewModel
        @MainActor
        func makeInsuranceViewModel(for type: InsuranceType) -> InsuranceViewModel {
            InsuranceViewModel(
                repository: makeInsuranceRepository(),
                category: type
            )
        }
    
    
    // 3. ✅ NEW Form VM Factory
        @MainActor
        func makeInsuranceFormViewModel(for type: InsuranceType) -> InsuranceFormViewModel {
            InsuranceFormViewModel(
                repository: makeInsuranceRepository(),
                category: type
            )
        }
}

extension DependencyContainer {
    
    // 1. Factory for Repository
    
    func makeAgentRepository() -> AgentRepositoryProtocol {
        
          AgentRepository(
                apiService: apiService,
               // context: coreDataManager.context
            )
        }

    
    
    // 2. Factory for ViewModel
        @MainActor
        func makeAgentViewModel() -> AgentViewModel {
            AgentViewModel(
                repository: makeAgentRepository()
               
            )
        }
    
    
   
}


