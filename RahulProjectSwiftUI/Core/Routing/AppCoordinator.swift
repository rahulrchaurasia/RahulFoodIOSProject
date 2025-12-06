//
//  AppCoordinator.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 09/09/25.
//

/*
 AppCoordinator – flow management
 ✅ Key: AppCoordinator only decides which flow to show, never handles inner navigation.
 
 
 ✅ Centralized high-level flow management

  >> currentFlow: AppFlow tracks which root module is active (onboarding, login, home).

 >> Observes AppState (isLoggedIn and hasCompletedOnboarding) to switch flows automatically.

 >> determineInitialFlow() correctly sets the initial root flow when the app launches.

 Separation of responsibilities
 */
import Foundation


import Foundation
import Combine

enum AppFlow {
    case onboarding, login, home
}

final class AppCoordinator: ObservableObject, AppCoordinatorProtocol {
   
    // typed path of destinations (NavigationStack can bind to this)
    @Published var navigationPath: [AppDestination] = []

    // which root module is active
    @Published var currentFlow: AppFlow = .onboarding
    
    // ✅ 1. Add state to control the side menu's visibility.
       @Published var showMenu = false


    private weak var appState: AppState?
    private var cancellables = Set<AnyCancellable>()

    // ✅ 2. Add a helper to check if the menu should be accessible.
        var isMenuAvailable: Bool {
            currentFlow == .home
        }
    // setup after AppState is created (avoid init-time cycles)
    func setup(with appState: AppState) {
        self.appState = appState
        setupObservers()
        determineInitialFlow()
    }

    private func setupObservers() {
        guard let appState = appState else { return }

        appState.$hasCompletedOnboarding
            .dropFirst()
            .sink { [weak self] completed in
                if completed && self?.currentFlow == .onboarding {
                    self?.completeOnboarding()
                }
            }
            .store(in: &cancellables)


        appState.$isLoggedIn
            .dropFirst()
            .sink { [weak self] isLoggedIn in
                self?.handleLoginStateChange(isLoggedIn)
            }
            .store(in: &cancellables)
    }

    private func determineInitialFlow() {
        guard let appState = appState else { return }
        if appState.isLoggedIn {
            currentFlow = .home
        } else if appState.hasCompletedOnboarding {
            currentFlow = .login
        } else {
            currentFlow = .onboarding
        }
    }

    private func handleLoginStateChange(_ isLoggedIn: Bool) {
        if isLoggedIn && currentFlow == .login {
            completeLogin()
        } else if !isLoggedIn {
            logout()
        }
    }

    // MARK: - Flow transitions
    func completeOnboarding() {
        navigationPath.removeAll()
        currentFlow = .login
    }

    func completeLogin() {
        navigationPath.removeAll()
        currentFlow = .home
    }

    func logout() {
        // ✅ 3. Reset menu state on logout to ensure a clean UI.
        showMenu = false
        navigationPath.removeAll()
        currentFlow = .login
    }

    // MARK: - deep navigation
    func navigate(to destination: AppDestination) {
        navigationPath.append(destination)
    }

    func navigateBack() {
        guard !navigationPath.isEmpty else { return }
        navigationPath.removeLast()
    }

    //Mark : used coordinator.pop(steps: 2) // goes back 2 screens
    func pop(steps: Int) {
        guard steps > 0, steps <= navigationPath.count else { return }
        navigationPath.removeLast(steps)
    }
    
    /*
     popToPreviousCase(_:)

     Pops screens up to the last occurrence of a specific type (AppDestination case).
     You must know the type you want to pop to.
     Very straightforward and type-specific.

     eg:  coordinator.popToPreviousCase(.profileScreen)


     Pops everything above the last .profileScreen in the stack.

     ✅ Simple, safe, but less flexible.
     */
    func popToPreviousCase(_ type: AppDestination) {
        guard let index = navigationPath.lastIndex(where: { $0.isSameCase(as: type) }) else { return }
        navigationPath = Array(navigationPath.prefix(through: index))
    }
    
    
    // ex: a>coordinator.popUntil { $0.isSameCase(as: .profileScreen) }
    //  b> Pop until a custom condition
    /*
     coordinator.popUntil { destination in
         destination.shouldStayInStack // some property in AppDestination
     }
     */
    func popUntil(_ predicate: (AppDestination) -> Bool) {
        guard !navigationPath.isEmpty else { return }

        // Find the last index where predicate is true
        if let index = navigationPath.lastIndex(where: predicate) {
            // Keep everything up to that index
            navigationPath = Array(navigationPath.prefix(through: index))
        } else {
            // If no screen matches, pop all (optional)
            navigationPath.removeAll()
        }
    }

    func popToRoot() {
        navigationPath.removeAll()
    }
    
    func navigatePreview(to destination: AppDestination) {
        
        print(" MOCK COORDINATOR: navigate to other screen")
    }
    
}


/*********************  For Preview Handling ******************************************
 

//Define a Coordinator Protocol (Most Important Step)
First, define a protocol for your coordinator. This decouples your views from a concrete implementation, which makes mocking incredibly easy.
 
 
                                
 ***********************************************************/
protocol AppCoordinatorProtocol: ObservableObject {
    
    func navigatePreview(to destination: AppDestination)
    
}
