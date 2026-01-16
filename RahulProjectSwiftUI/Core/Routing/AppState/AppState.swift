//
//  AppState.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 09/09/25.
//


import Foundation
import Combine
import SwiftUICore

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
    @Published private(set) var hasCompletedOnboarding: Bool
    @Published private(set) var isLoggedIn: Bool
    @Published private(set) var isOnline: Bool = true
    
    private let connectivityMonitor: ConnectivityMonitor
    private let userDefaults: UserDefaultsManager
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Theme
    @Published private(set) var themePreference: ThemePreference
   


    init(
        
        connectivityMonitor: ConnectivityMonitor,
        userDefaults: UserDefaultsManager = .shared
    ) {
        // Read persisted flags (or default false)
        //        self.hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        //        self.isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        
        //let defaults = UserDefaultsManager.shared
        
        self.userDefaults = userDefaults
        self.connectivityMonitor = connectivityMonitor
       
        self.hasCompletedOnboarding = userDefaults.hasSeenOnboarding
        self.isLoggedIn = userDefaults.isLoggedIn
        //self.colorScheme = userDefaults.isDarkMode ? .dark : .light
        
        self.themePreference = userDefaults.themePreference
        
        observeConnectivity()
    }
    
    //Mark : Handle Color Scheme
    // MARK: - Theme Actions
      func setTheme(_ theme: ThemePreference) {
          themePreference = theme
          userDefaults.themePreference = theme
       }
    
    
    /// ✅ Derived state (NO @Published)
       var colorScheme: ColorScheme? {
           themePreference.colorScheme
       }

    func completeOnboarding() {
        hasCompletedOnboarding = true
        userDefaults.hasSeenOnboarding = true
    }

    func login() {
        isLoggedIn = true
        userDefaults.isLoggedIn = true
    }

//    func logout() {
//        isLoggedIn = false
//        //UserDefaults.standard.set(false, forKey: "isLoggedIn")
//        userDefaults.logoutUser()
//    }
    
    func logout(resetOnboarding: Bool = false) {
            // 1) Clear persisted user-specific data
           // UserDefaultsManager.shared.clearUserSessionData(clearOnboarding: resetOnboarding)
            userDefaults.clearAllCompletely()

            // 2) Update runtime state
            isLoggedIn = false
        
             if resetOnboarding {
                   
                 hasCompletedOnboarding = false
              }
        
//            if resetOnboarding == false {
//                // keep hasCompletedOnboarding as-is (usually true)
//                hasCompletedOnboarding = UserDefaultsManager.shared.hasSeenOnboarding
//            } else {
//                hasCompletedOnboarding = false
//            }
        }
}

private extension AppState {

    func observeConnectivity() {
        connectivityMonitor.statusPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isConnected in
                self?.isOnline = isConnected
            }
            .store(in: &cancellables)
    }
}
