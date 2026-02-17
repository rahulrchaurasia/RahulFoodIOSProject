//
//  AppState.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 09/09/25.
//


import Foundation
import Combine
import SwiftUI
import CoreData

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
   
    @Published private(set) var isLoggedIn: Bool
    @Published private(set) var hasCompletedOnboarding: Bool
    
    @Published private(set) var isOnline: Bool = true
    
    private let connectivityMonitor: ConnectivityMonitor
    private let userDefaults: UserDefaultsManager
    private var cancellables = Set<AnyCancellable>()
    
    private let coreData: CoreDataManager
    // MARK: - Theme
    @Published private(set) var themePreference: ThemePreference
   


    init(
        
        connectivityMonitor: ConnectivityMonitor,
        userDefaults: UserDefaultsManager = .shared,
        coreData: CoreDataManager = .shared
    ) {
        // Read persisted flags (or default false)
        //        self.hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        //        self.isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        
        //let defaults = UserDefaultsManager.shared
        
        self.userDefaults = userDefaults
        self.coreData = coreData
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


    
    private func clearCoreData() {
            let context = coreData.context
            context.performAndWait {
                let entities = context.persistentStoreCoordinator?.managedObjectModel.entities ?? []
                for entity in entities {
                    let request = NSBatchDeleteRequest(
                        fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: entity.name!)
                    )
                    try? context.execute(request)
                }
                try? context.save()
            }
        }
    
    /// 🔥 SINGLE logout entry point
    func logout() {
            // 1️⃣ Clear persistence
//            userDefaults.clearAllCompletely()
//            clearCoreData()
//
//            // 2️⃣ Update runtime state
//            isLoggedIn = false
//            hasCompletedOnboarding = userDefaults.hasSeenOnboarding
            
        
        print("🔴 AppState.logout() called")
         print("   Before: isLoggedIn=\(isLoggedIn), hasOnboarding=\(hasCompletedOnboarding)")
                
        // ✅ STEP 1: Store onboarding state BEFORE clearing anything
            // This prevents users from being sent back to onboarding screen
            let wasOnboardingCompleted = hasCompletedOnboarding
            
            // ✅ STEP 2: Clear user session data (NOT onboarding state)
            // Changed from clearAllCompletely() to clearUserData()
        
               userDefaults.clearAllCompletely()
                    
                // ✅ STEP 3: Clear CoreData
                clearCoreData()
                
                // ✅ STEP 4: Update login state
                // This triggers the observer in AppCoordinator
                isLoggedIn = false
                
                // ✅ STEP 5: Restore onboarding state
                // This ensures determineInitialFlow() sends users to login, not onboarding
                if wasOnboardingCompleted {
                    Task { @MainActor in
                        self.hasCompletedOnboarding = true
                        self.userDefaults.hasSeenOnboarding = true
                    }
                }
                
                print("   After: isLoggedIn=\(isLoggedIn), hasOnboarding=\(hasCompletedOnboarding)")
                print("✅ AppState.logout() completed")
        
        
            
            // 1️⃣ Save the onboarding status before wiping data
//                let hadSeenOnboarding = userDefaults.hasSeenOnboarding
//                
//                // 2️⃣ Clear persistence (Keep your existing clear logic)
//                userDefaults.clearAllCompletely()
//                clearCoreData()
//                
//                // 3️⃣ RESTORE onboarding status so we go to Login, not Onboarding
//                userDefaults.hasSeenOnboarding = hadSeenOnboarding
//                
//                // 4️⃣ Update runtime state (On Main Thread)
//                Task { @MainActor in
//                    self.hasCompletedOnboarding = hadSeenOnboarding
//                    self.isLoggedIn = false
//                }
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
