//
//  CoordinatorView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 09/09/25.
//


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
                  
                    HomeView() // no init(homeVM:)
                        .transition(.asymmetric(insertion: .opacity.combined(with: .scale), removal: .opacity))
                }
            }
            .animation(.easeInOut(duration: 0.3), value: coordinator.currentFlow)
            .navigationDestination(for: AppDestination.self) { destination in
                destination.destinationView(container: container)
                    .navigationBarBackButtonHidden(true)
            }
        }
        
    }
}
