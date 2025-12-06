//
//  AppState.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 09/09/25.
//


import Foundation
import Combine

/*
 
 ***** AppState – runtime observable state *******
 
  >>>> What AppState gives you

 Observable runtime state (@Published) → SwiftUI reacts automatically.

 Centralized source of truth for UI → views don’t care about persistence.

 Encapsulates logic: login, logout, onboarding complete.

 Persistence handled internally: no duplication in views or flows.
 
 
 Verdict:
 * AppState is necessary for good architecture.
 * Treat it as runtime state layer on top of persistence.
 * Views, coordinators, and flows interact only with AppState.
 * UserDefaultsManager is purely storage, no reactivity.



 @EnvironmentObject var appState: AppState

 Button("Logout") {
     appState.logout()
 }
 SwiftUI automatically reacts and AppCoordinator sees the change and switches flow.

 No direct coupling to UserDefaultsManager in views.


 3️⃣ Architectural View
 Think of it as layers:

 +-------------------+
 | SwiftUI Views     |  <-- observe runtime state (AppState)
 +-------------------+
          |
          v
 +-------------------+
 | AppState          |  <-- runtime state, @Published, logic
 +-------------------+
          |
          v
 +-------------------+
 | UserDefaultsManager | <-- persistent storage
 +-------------------+

 * Separation of concerns:
     * Views: display UI based on AppState
     * AppState: runtime state + business logic
     * UserDefaultsManager: persistence only
 ✅ This is clean, testable, scalable.

 */




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
