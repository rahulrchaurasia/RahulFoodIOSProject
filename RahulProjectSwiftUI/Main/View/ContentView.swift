//
//  ContentView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 13/11/24.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var authVM : AuthViewModel
    @EnvironmentObject var userVM : UserViewModel
    @EnvironmentObject var router : Router
    var body: some View {
       // Group {
        switch router.root {
            case .onboardingModule:
                 OnboardingView()
               // LoginView()
            case .loginModule:
                LoginNewView()
            case .dashboardModule:
                HomeView()
            }
       // }
       // .animation(.easeInOut, value: authVM.currentAuthState)
    }

}

#Preview {
    ContentView()
}
