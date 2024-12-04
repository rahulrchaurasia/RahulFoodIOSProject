//
//  RahulProjectSwiftUIApp.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 13/11/24.
//

import SwiftUI



@main
struct RahulProjectSwiftUIApp: App {
    
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject private var authVM = AuthViewModel()

    @StateObject private var router = Router()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.navPath) {
                ContentView()
                    .navigationDestination(for: Router.AuthFlow.self) { destination in
                        
                        router.destination(for: destination)
                    }
            }
            .environmentObject(authVM )
            .environmentObject(router)
        }
    }
}
