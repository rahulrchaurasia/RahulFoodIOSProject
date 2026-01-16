//
//  CoordinatorLatestView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 25/09/25.
//

import SwiftUI


// NOT IN USED 
struct CoordinatorLatestView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var coordinator: AppCoordinator

    let container: DependencyContainer

    var body: some View {
        // ✅ 1. The root view is now a ZStack to layer the menu over the content
        ZStack {
            // MARK: - Layer 1: Main Content
            NavigationStack(path: $coordinator.navigationPath) {
                // ... your existing switch statement for flows ...
                switch coordinator.currentFlow {
                case .onboarding:
                    Text("Onboarding View") // Replace with your view
                case .login:
                    LoginNewView() // Replace with your view
                case .home:
                    HomeView(viewModel: container.makeCarViewModel()) // HomeView is now much simpler
                }
            }
            .navigationDestination(for: AppDestination.self) { destination in
                destination.destinationView(container: container)
                    .navigationBarBackButtonHidden(true) // This remains as is
            }
            // ✅ 2. Apply scaling and offset to the ENTIRE NavigationStack
            .scaleEffect(coordinator.showMenu ? 0.9 : 1)
            .offset(x: coordinator.showMenu ? UIScreen.main.bounds.width * 0.75 : 0)
            .shadow(color: coordinator.showMenu ? .black.opacity(0.2) : .clear, radius: 10)
            .disabled(coordinator.showMenu)
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: coordinator.showMenu)


            // MARK: - Layer 2: Scrim (Dimming Overlay)
            if coordinator.showMenu {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .onTapGesture {
                        coordinator.showMenu = false
                    }
            }
            
            // MARK: - Layer 3: Side Menu
            if coordinator.showMenu {
                HStack {
                    SideMenuView(isShowing: $coordinator.showMenu)
                        .transition(.move(edge: .leading))
                    Spacer()
                }
                .zIndex(100) // Ensure it's always on top
            }
        }
        // Only allow drag gesture if the menu should be available
        .gesture(coordinator.isMenuAvailable ? dragGesture : nil)
    }
    
    // ✅ 3. The drag gesture to open/close the menu now lives here
    private var dragGesture: some Gesture {
        DragGesture()
            .onEnded { gesture in
                if gesture.translation.width > 50 && !coordinator.showMenu {
                    coordinator.showMenu = true
                } else if gesture.translation.width < -50 && coordinator.showMenu {
                    coordinator.showMenu = false
                }
            }
    }
}

