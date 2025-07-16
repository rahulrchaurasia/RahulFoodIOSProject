//
//  AppState.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 23/04/25.
//

import Foundation
import SwiftUI

//Mark : Module level Maintainanace
enum AuthState : String {
    
    case onboardingModule
    case loginModule
    case dashboardModule
}

// MARK: - App-Level Router with AuthState Integration

//AppStateRouter will manage the root login/onboarding module level


// AppStateRouter using composition (NO inheritance)
final class AppStateRouter: ObservableObject {
    private let container: DependencyContainer
    @Published var navPath = NavigationPath()

    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    @AppStorage("authRoot") private var storedRoot: AuthState = AuthState.onboardingModule

    init(container: DependencyContainer) {
        self.container = container
    }

    // AUTH ROOT
    var root: AuthState {
        get {
            if !hasSeenOnboarding {
                return .onboardingModule
            } else if !isUserLoggedIn() {
                return .loginModule
            } else {
                return .dashboardModule
            }
        }
        set {
            storedRoot = newValue
        }
    }

    func setRoot(_ root: AuthState) {
        self.root = root
    }

    private func isUserLoggedIn() -> Bool {
        UserDefaults.standard.bool(forKey: "isLoggedIn")
    }
    
    func logout() {
            // 1. Clear login session
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            
            // 2. Reset root to login
            setRoot(.loginModule)
            
            // 3. Clear navigation stack
            navPath.removeLast(navPath.count)
            
            print("User logged out successfully")
        }

    
    // NORMAL PUSH NAVIGATION
    func navigate(to route: AppRoute) {
        navPath.append(route)
    }

    func navigateBack() {
        guard !navPath.isEmpty else { return }
        navPath.removeLast()
    }

    func navigateToRoot() {
        navPath.removeLast(navPath.count)
    }
    
}





//final class AppStateRouter: AppRouter {
//    private let container: DependencyContainer
//
//    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
//    @AppStorage("authRoot") private var storedRoot: String = AuthState.onboardingModule.rawValue
//
//    init(container: DependencyContainer) {
//        self.container = container
//        super.init()
//    }
//
//    var root: AuthState {
//        get {
//            if !hasSeenOnboarding {
//                return .onboardingModule
//            } else if !isUserLoggedIn() {
//                return .loginModule
//            } else {
//                return .dashboardModule
//            }
//        }
//        set {
//            storedRoot = newValue.rawValue
//        }
//    }
//
//    private func isUserLoggedIn() -> Bool {
//        UserDefaults.standard.bool(forKey: "isLoggedIn")
//    }
//}


// MARK: - Main App Entry Point

