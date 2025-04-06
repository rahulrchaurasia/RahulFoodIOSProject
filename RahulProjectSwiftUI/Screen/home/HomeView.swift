//
//  HomeView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 22/11/24.
//

import SwiftUI

// Mark : navigationDestination demo
struct HomeView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var userVM: UserViewModel
    @EnvironmentObject var router: Router
    
    @State private var tabSelection = 0
    @State private var selectedTab: BottomNavigationView.TabItem = .home
    
    // Menu state
    @State private var showMenu = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack(alignment: .leading) {
                // Main content
                TabContentView(selectedTab: selectedTab)
                //Mark : Below line handle Side menu,contain open 75 percentage
                    .offset(x: showMenu ? UIScreen.main.bounds.width * 0.75 : 0)
                    .scaleEffect(showMenu ? 0.9 : 1)
                    .shadow(color: showMenu ? .black.opacity(0.2) : .clear, radius: 10)
                    .disabled(showMenu)
                
                //Mark :Side menu, Dark overlay when menu is showing
                if showMenu {
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
                
                // Side menu
                if showMenu {
                    SideMenuView(isShowing: $showMenu)
                        .transition(.move(edge: .leading))
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
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
                
                ToolbarItem(placement: .principal) {
                    Text(selectedTab.rawValue) // Dynamic title based on tab
                        .font(.headline)
                        .opacity(showMenu ? 0 : 1)
                }
            }
            .gesture(
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
                    }
            )
            
            // BottomNavigationView should be INSIDE the outer ZStack
            if !showMenu {
                BottomNavigationView(selectedTab: $selectedTab)
                    .padding(.bottom, 8)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }
}

#Preview {
    HomeView()
    
  
    .environmentObject(Router())
    .environmentObject(AuthViewModel())
}




