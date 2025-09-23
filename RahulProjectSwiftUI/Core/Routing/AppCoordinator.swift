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

final class AppCoordinator: ObservableObject {
    // typed path of destinations (NavigationStack can bind to this)
    @Published var navigationPath: [AppDestination] = []

    // which root module is active
    @Published var currentFlow: AppFlow = .onboarding

    private weak var appState: AppState?
    private var cancellables = Set<AnyCancellable>()

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

//        appState.$isLoggedIn
//            .dropFirst()
//            .sink { [weak self] logged in
//                // swiftlint off:next identifier_name
//                _ = logged
//            }
//            .store(in: &cancellables)

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

    func popToRoot() {
        navigationPath.removeAll()
    }
}
