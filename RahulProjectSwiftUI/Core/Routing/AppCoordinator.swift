//
//  AppCoordinator.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 09/09/25.
//

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
    
    func popToPreviousCase(_ type: AppDestination) {
        guard let index = navigationPath.lastIndex(where: { $0.isSameCase(as: type) }) else { return }
        navigationPath = Array(navigationPath.prefix(through: index))
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
