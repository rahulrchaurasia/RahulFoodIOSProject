//
//  MockDependencyContainer.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 08/09/25.
//


class MockDependencyContainer: DependencyContainer {
    
    //Mark : Home
    override func makeHomeRepository() -> HomeRepositoryProtocol {
        MockHomeRepository()
    }
    
    override func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel(homeRepository: makeHomeRepository())
    }
    
    //    override func makeAuthViewModel() -> AuthViewModel {
    //        AuthViewModel(userRepository: MockUserRepository()) // <- if you add a mock
    //    }
    
    
    //Mark : Car
    override func makeCarRepository() ->  CarRepositoryProtocol {
        MockCarRepository()
    }
    
    override func makeCarViewModel() -> CarViewModel {
        
        CarViewModel(carRepository: makeCarRepository())
    }
    // MARK: - Coordinator Factories
    @MainActor
    override func makeAppCoordinator() -> AppCoordinatorProtocol {
        print("✅ Creating a MOCK AppCoordinator.")
        return AppCoordinator()
    }
    
}
