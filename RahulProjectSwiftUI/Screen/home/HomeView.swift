//
//  HomeView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 22/11/24.
//
/*
 showMenu && selectedTab == .home :
 Navigation View Only show when showMenu is true and we selected HomeTab
 */

import SwiftUI

// Mark : navigationDestination demo
// Mark : navigationDestination demo

/*
 Type Consistency:

 Views expect dependencies (repositories/services)

 Containers provide correctly typed instances

Note : Using init we expect  init(repository: HomeRepositoryProtocol)
 HomeRepositoryProtocol hence we have to pass when we called it
 via   HomeView(repository: container.makeHomeRepository()
 */
struct HomeView: View {
    @EnvironmentObject var homeVM: HomeViewModel
    @EnvironmentObject var userVM: UserViewModel
    
    @StateObject private var carVM: CarViewModel
    
    @State private var selectedTab: BottomNavigationView.TabItem = .home
    @State private var showMenu = false
    
    init(viewModel: CarViewModel) {
            _carVM = StateObject(wrappedValue: viewModel)
        }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {

                ZStack(alignment: .bottom) {
                    // Main tab content
                    TabContentView(carVM: carVM, selectedTab: selectedTab)
                        .offset(x: showMenu && selectedTab == .home ? UIScreen.main.bounds.width * 0.75 : 0)
                        .scaleEffect(showMenu && selectedTab == .home ? 0.9 : 1)
                    
                    // Bottom navigation
                    BottomNavigationView(selectedTab: $selectedTab)
                        .padding(.bottom, 8)
                        .offset(x: showMenu && selectedTab == .home ? UIScreen.main.bounds.width * 0.75 : 0)
                        .scaleEffect(showMenu && selectedTab == .home ? 0.9 : 1)
                        .onChange(of: selectedTab) { newValue in
                            if newValue != .home && showMenu {
                                withAnimation(.spring()) { showMenu = false }
                            }
                        }
                }
                .shadow(color: showMenu && selectedTab == .home ? .black.opacity(0.2) : .clear, radius: 10)
                .disabled(showMenu && selectedTab == .home)
                
                
            }
            
            .safeAreaInset(edge: .top) {
                
                // ✅ only show on Home
                HomeHeaderWithMenu(title: "Home", showMenuIcon: selectedTab == .home ) {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        showMenu.toggle()
                    }
                }
            }
            
            // Scrim overlay
            if showMenu && selectedTab == .home {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring()) { showMenu = false }
                    }
            }
            
            // Side menu on top
            if showMenu && selectedTab == .home {
                HStack(alignment: .top) {
                    SideMenuView(isShowing: $showMenu)
                        .ignoresSafeArea() // ✅ menu covers full screen
                        .transition(.move(edge: .leading))
                    Spacer()
                }
                .zIndex(100)
            }
        }
        // ✅ Hide system bar completely
        .navigationBarHidden(true)
        .gesture(
            selectedTab == .home ?
            DragGesture()
                .onEnded { gesture in
                    if gesture.translation.width > 50 && !showMenu {
                        withAnimation(.spring()) { showMenu = true }
                    } else if gesture.translation.width < -50 && showMenu {
                        withAnimation(.spring()) { showMenu = false }
                    }
                } : nil
        )
    }
    
    
  
        
}


#Preview {
    let container = PreviewDependencies.container
    
    HomeView(viewModel: container.makeCarViewModel())
        .environmentObject(UserViewModel())
        .environmentObject(container.makeHomeViewModel())
       
       // .environmentObject(Router(container: container))
}

