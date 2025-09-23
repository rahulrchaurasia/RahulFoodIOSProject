//
//  AppState.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 09/09/25.
//


import Foundation
import Combine

//Note : AppState here is acting like a session manager that’s backed by UserDefaults.
//
//@MainActor
//final class AppState: ObservableObject {
//    @Published var hasCompletedOnboarding: Bool
//    @Published var isLoggedIn: Bool
//
//    init() {
//        let defaults = UserDefaultsManager.shared
//        self.hasCompletedOnboarding = defaults.hasSeenOnboarding
//        self.isLoggedIn = defaults.isLoggedIn
//    }
//
//    func completeOnboarding() {
//        hasCompletedOnboarding = true
//        UserDefaultsManager.shared.hasSeenOnboarding = true
//    }
//
//    func login() {
//        isLoggedIn = true
//        UserDefaultsManager.shared.isLoggedIn = true
//    }
//
//    func logout(resetOnboarding: Bool = false) {
//        UserDefaultsManager.shared.clearAllCompletely()
//        
//        isLoggedIn = false
//        hasCompletedOnboarding = resetOnboarding ? false : UserDefaultsManager.shared.hasSeenOnboarding
//    }
//}
//

final class AppState: ObservableObject {
    @Published var hasCompletedOnboarding: Bool
    @Published var isLoggedIn: Bool

    init() {
        // Read persisted flags (or default false)
        //        self.hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        //        self.isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        
        let defaults = UserDefaultsManager.shared
        self.hasCompletedOnboarding = defaults.hasSeenOnboarding
        self.isLoggedIn = defaults.isLoggedIn
    }

    func completeOnboarding() {
        hasCompletedOnboarding = true
        UserDefaultsManager.shared.hasSeenOnboarding = true
    }

    func login() {
        isLoggedIn = true
        UserDefaultsManager.shared.isLoggedIn = true
    }

    func logout() {
        isLoggedIn = false
        //UserDefaults.standard.set(false, forKey: "isLoggedIn")
        UserDefaultsManager.shared.logoutUser()
    }
    
    func logout(resetOnboarding: Bool = false) {
            // 1) Clear persisted user-specific data
           // UserDefaultsManager.shared.clearUserSessionData(clearOnboarding: resetOnboarding)
        UserDefaultsManager.shared.clearAllCompletely()

            // 2) Update runtime state
            isLoggedIn = false
            if resetOnboarding == false {
                // keep hasCompletedOnboarding as-is (usually true)
                hasCompletedOnboarding = UserDefaultsManager.shared.hasSeenOnboarding
            } else {
                hasCompletedOnboarding = false
            }
        }
}
