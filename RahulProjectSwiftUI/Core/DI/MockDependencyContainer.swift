class MockDependencyContainer: DependencyContainer {
    override func makeHomeRepository() -> HomeRepositoryProtocol {
        MockHomeRepository()
    }
    
    override func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel(homeRepository: makeHomeRepository())
    }
    
    override func makeAuthViewModel() -> AuthViewModel {
        AuthViewModel(userRepository: MockUserRepository()) // <- if you add a mock
    }
}
