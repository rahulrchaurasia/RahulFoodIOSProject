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
struct HomeView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var userVM: UserViewModel
    @EnvironmentObject var router: Router
    
    @State private var selectedTab: BottomNavigationView.TabItem = .home
    @State private var showMenu = false
    
    var body: some View {
        ZStack {
            // Main content including bottom navigation
            ZStack(alignment: .bottom) {
                TabContentView(selectedTab: selectedTab)
                    .offset(x: showMenu && selectedTab == .home ? UIScreen.main.bounds.width * 0.75 : 0)
                    .scaleEffect(showMenu && selectedTab == .home ? 0.9 : 1)
                
                // Bottom Navigation
                BottomNavigationView(selectedTab: $selectedTab)
                    .padding(.bottom, 8)
                    .offset(x: showMenu && selectedTab == .home ? UIScreen.main.bounds.width * 0.75 : 0)
                    .scaleEffect(showMenu && selectedTab == .home ? 0.9 : 1)
                    .onChange(of: selectedTab) { newValue in
                        if newValue != .home && showMenu {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                showMenu = false
                            }
                        }
                    }
            }
            .shadow(color: showMenu && selectedTab == .home ? .black.opacity(0.2) : .clear, radius: 10)
            .disabled(showMenu && selectedTab == .home)
            
            // Overlay when menu is showing - this needs to be above everything
            if showMenu && selectedTab == .home {
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            showMenu = false
                        }
                    }
            }
            
            // Side menu - this should be the topmost layer
            if showMenu && selectedTab == .home {
                HStack(alignment: .top) {
                    SideMenuView(isShowing: $showMenu)
                        .transition(.move(edge: .leading))
                    
                    Spacer()
                }
                .zIndex(100) // Ensure it's above everything
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if selectedTab == .home {
                    Button {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            showMenu.toggle()
                        }
                    } label: {
                        Image(systemName: "line.horizontal.3")
                            .imageScale(.large)
                            .foregroundColor(showMenu ? .clear : .primary)
                    }
                }
            }
            
            ToolbarItem(placement: .principal) {
                Text(selectedTab.rawValue)
                    .font(.headline)
                    .opacity(showMenu && selectedTab == .home ? 0 : 1)
            }
        }
        .gesture(
            selectedTab == .home ?
            DragGesture()
                .onEnded { gesture in
                    if gesture.translation.width > 50 && !showMenu {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            showMenu = true
                        }
                    } else if gesture.translation.width < -50 && showMenu {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            showMenu = false
                        }
                    }
                } : nil
        )
    }
}
#Preview {
    HomeView()
    
  
    .environmentObject(Router())
    .environmentObject(AuthViewModel())
}




