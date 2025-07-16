//
//  ContentView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 13/11/24.
//

import SwiftUI

struct ContentView: View {
    
    let container: DependencyContainer
    @EnvironmentObject var authVM : AuthViewModel
    @EnvironmentObject var userVM : UserViewModel
  
    @EnvironmentObject var router : AppStateRouter
    
    
    @StateObject private var loginRouter = LoginFlowRouter()
    var body: some View {
        // Group {
        switch router.root {
        case .onboardingModule:
            OnboardingView()
            // LoginView()
        case .loginModule:
            
             LoginNewView()
           
        case .dashboardModule:
            HomeView(repository: container.makeHomeRepository())
         
            
        }
        // }
        // .animation(.easeInOut, value: authVM.currentAuthState)
    }

}

#Preview {
    
    
    let container = DependencyContainer()
    ContentView(container: container)
        .environmentObject(AuthViewModel(userRepository: DependencyContainer().userRepository))
           .environmentObject(UserViewModel())
           .environmentObject(Router(container: container))
}
