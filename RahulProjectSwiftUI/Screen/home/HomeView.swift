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

/*
 
 Note: Handling bottom navigation when Keyboard open :---->
 
 .ignoresSafeArea(.keyboard, edges: .bottom) tells SwiftUI:
 
 “Even when the keyboard opens, don’t adjust this view for it. Keep the layout fixed to the bottom.”
 
 So,
 ✅ Your bottom navigation bar will stay anchored at the bottom.
 
 ✅ Your tab content won’t shrink or shift upward.

 ✅ The keyboard will simply overlay above your bottom bar when open.


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
            // MARK: - Main content + Bottom Nav
            VStack(spacing: 0) {
                ZStack(alignment: .bottom) {
                    // Main tab content
                    TabContentView(
                        carVM: carVM,
                        selectedTab: selectedTab,
                        showMenu: $showMenu
                    )
                    .offset(x: showMenu && selectedTab == .home ? UIScreen.main.bounds.width * 0.75 : 0)
                    .scaleEffect(showMenu && selectedTab == .home ? 0.9 : 1)
                    
                    
                   
                }
                .shadow(color: showMenu && selectedTab == .home ? .black.opacity(0.2) : .clear, radius: 10)
                .disabled(showMenu && selectedTab == .home)
            }
           // .ignoresSafeArea(.keyboard, edges: .bottom)
            
            // Apply safeAreaInset to the main container
            .safeAreaInset(edge: .bottom, spacing: 0) {
                
                BottomNavigationView(selectedTab: $selectedTab)
                    //.padding(.bottom, 8)
                    .padding(.bottom, 0) // ✅ No need for extra padding
                //***1***
                //.background(Color.bg.ignoresSafeArea(edges: .bottom))
                //Note :So your nav bar’s rounded capsule, icons, etc. will sit on top of that solid background color instead of showing what’s behind (e.g., scroll view content).
                
                //***2***
                //ignoresSafeArea(edges: .bottom) part
                 //This means:
                 // “Extend that background color past the safe area inset at the bottom — all the way down to the screen’s physical edge.”

                    .background(Color.bg.ignoresSafeArea(edges: .bottom))
                    .offset(x: showMenu && selectedTab == .home ? UIScreen.main.bounds.width * 0.75 : 0)
                    .scaleEffect(showMenu && selectedTab == .home ? 0.9 : 1)
                    .onChange(of: selectedTab) { newValue in
                        if newValue != .home && showMenu {
                            withAnimation(.spring()) { showMenu = false }
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
                        .ignoresSafeArea()
                        .transition(.move(edge: .leading))
                    Spacer()
                }
                .zIndex(100)
            }
        }
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

