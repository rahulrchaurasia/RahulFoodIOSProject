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


 */
struct HomeView: View {
    
    @EnvironmentObject var userVM: UserViewModel
   
    @EnvironmentObject var router: AppStateRouter
    
   
   // The ViewModel is now injected instead of created here
    
        @StateObject var homeVM: HomeViewModel // Owned here
    
    @State private var selectedTab: BottomNavigationView.TabItem = .home
    @State private var showMenu = false
    
    init(repository: HomeRepositoryProtocol) {
           _homeVM = StateObject(wrappedValue:
               HomeViewModel(homeRepository: repository) // ← Use injected parameter
           )
       }
    
    var body: some View {
        ZStack {
            // Main content including bottom navigation
            ZStack(alignment: .bottom) {
                // TabView with content
                TabContentView(homeVM: homeVM, selectedTab: selectedTab)
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
            
            ////added here 007
            .task {
                // Only load data if not already loaded
                if !homeVM.hasLoadedInitialData {
                       await homeVM.getFoodDetails()
                   }
            }
            .alert(homeVM.alertState.title, isPresented: $homeVM.showError, actions: {
                Button("OK", role: .none, action: {})
            }, message: {
                Text(homeVM.errorMessage)
            })
            
            //end here 007
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
//#Preview {
//  
//    
//    let container = DependencyContainer()
//    HomeView(repository: container.makeHomeRepository())
//           .environmentObject(UserViewModel())
//           .environmentObject(Router(container: container))
//}


//#Preview {
//    let container = PreviewDependencies.container
//    
//     HomeView(repository: container.makeHomeRepository())
//        .environmentObject(container.makeUserViewModel())
//        .environmentObject(container.makeRouter())
//}

#Preview {
    let container = PreviewDependencies.container
    
     HomeView(repository: container.makeHomeRepository())
        .environmentObject(UserViewModel())
        .environmentObject(Router(container: container))
}

