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
    @StateObject private var userVM = UserViewModel()

    @StateObject private var router = Router()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.navPath) {
                
                ContentView()
                    .navigationDestination(for: Router.Destination.self) { destination in
                        
                        router.destination(for: destination)
                    }
//                if router.root == .loginModule {
//                   
//                    LoginView()
//                }else{
//                    HomeView()
//                        .navigationDestination(for: Router.Destination.self) { destination in
//                            
//                            router.destination(for: destination)
//                        }
//                }
               
            }
            .environmentObject(authVM )
            .environmentObject(userVM )
            .environmentObject(router)
        }
    }
}
