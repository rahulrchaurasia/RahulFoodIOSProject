//
//  CoordinatorView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 09/09/25.
//


/*
    Object                  Reason
 //************************************************//
 
 AppState                 Global session / auth
 AppCoordinator           App-wide navigation
 UserViewModel            Logged-in user
 HomeViewModel
 
 //************************************************//
 
 
 BIG PICTURE — Graphical Flow
                
                
                     ┌──────────────┐
                     │   App Launch │
                     └──────┬───────┘
                            │
                            ▼
                    @main App (Composition Root) creates:
                    ┌──────────────────────────────┐
                    │  DependencyContainer         │
                    │  AppState                    │
                    │  AppCoordinator              │
                    └──────────────┬───────────────┘
                            │
                            ▼
                    AppCoordinator.setup(with: appState)
                            │
                            ▼
                    observeLoginState() subscribes to appState.$isLoggedIn
                            │
                            ▼
                    determineInitialFlow() reads:
                    - isLoggedIn
                    - hasCompletedOnboarding
                            │
                            ▼
                    currentFlow is set:
                    ┌───────────────┬───────────────┬───────────────┐
                    │               │               │               │
                    onboarding        login             home


 🔁 LIVE DECISION LOOP (Runtime)
 User taps Login
         │
         ▼
 AppState.login()
   → isLoggedIn = true
         │
         ▼
 AppCoordinator.observeLoginState()
   → sees true
   → showHome()
   → currentFlow = .home
         │
         ▼
 CoordinatorView switch
   → HomeView is rendered

 🔁 LOGOUT FLOW
 User taps Logout
         │
         ▼
 AppState.logout()
   → isLoggedIn = false
         │
         ▼
 AppCoordinator.observeLoginState()
   → sees false
   → handleLogout()
   → determineInitialFlow()
         │
         ▼
 Reads:
   isLoggedIn = false
   hasCompletedOnboarding = true
         │
         ▼
 currentFlow = .login   ✅
         │
         ▼
 CoordinatorView renders LoginNewView

 🧭 WHY THIS IS PERFECT ARCHITECTURE
 Layer    Role
 AppState    Owns truth (isLoggedIn, onboarding, theme, network)
 Coordinator    Builds navigation graph from AppState
 Views    Pure UI – no navigation logic
 🎯 Interview One-Liner

 “isLoggedIn is the root switch of my navigation graph.
 AppState owns it, AppCoordinator observes it, and CoordinatorView renders the correct flow based on it.”

 🏁 FINAL SUMMARY GRAPH
 UserDefaults → AppState → AppCoordinator → CoordinatorView → Screens
 */
import SwiftUI


struct CoordinatorView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var coordinator: AppCoordinator

    let container: DependencyContainer   // ✅ injected, not recreated

    
    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            Group {
                switch coordinator.currentFlow {
                case .onboarding:
                    OnboardingView()
                        .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)))
                case .login:
                    LoginNewView()
                        .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)))
                case .home:
                  
                    HomeView(viewModel: container.makeCarViewModel()) // no init(homeVM:)
                        .transition(.asymmetric(insertion: .opacity.combined(with: .scale), removal: .opacity))
                }
            }
            /* Required For Logout done than redwa UI again on base of State
             id(coordinator.currentFlow) 🧠 What .id() does
             Forces SwiftUI to destroy the old view tree
             Creates a brand-new root
             Clears retained state
             Guarantees correct flow switch
             */
            .id(coordinator.currentFlow)  // ⭐⭐⭐ FIX // ✅ Force redraw when flow changes
            .animation(.easeInOut(duration: 0.3), value: coordinator.currentFlow)
            .navigationDestination(for: AppDestination.self) { destination in
                destination.destinationView(container: container)
                    .navigationBarBackButtonHidden(true)
            }
        }
        
    }
}
