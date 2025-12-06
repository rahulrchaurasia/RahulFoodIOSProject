//
//  RahulProjectSwiftUIApp.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 13/11/24.
//

//Note : For Splash Screen Add in info :
/*
    <key>UILaunchStoryboardName</key>
    <string>LaunchScreen</string>
 
 */


//*************************************************************************
/*
 Persistence layer (UserDefaults) → UserDefaultsManager (responsible for read/write).

 Session / auth coordinator → SessionManager or AuthService (single API for login/logout actions; orchestrates persistence + runtime state).

 Runtime state → AppState (in-memory, ObservableObject used by UI and observed by AppCoordinator).

 Navigation → AppCoordinator observes AppState and reacts (no view should directly manipulate the coordinator for root-level flow unless intentionally).
 */

//*************************************************************************

import SwiftUI



    @main
    struct RahulProjectSwiftUIApp: App {
        
        private let container: DependencyContainer
        
        
        // 2. Declare StateObjects without initialization
        @StateObject private var userVM: UserViewModel
        
        @StateObject private var homeVM : HomeViewModel

        @StateObject private var appState : AppState
        
        @StateObject private var coordinator : AppCoordinator
        // 3. Initialize everything in init()
        init()
        {
            //Lazy Initialization (Recommended)
            let container = DependencyContainer()
            self.container = container
            _userVM = StateObject(wrappedValue: UserViewModel())
            _appState = StateObject(wrappedValue: AppState())
            _coordinator = StateObject(wrappedValue: AppCoordinator())
            _homeVM = StateObject(wrappedValue: container.makeHomeViewModel())
        }
        
        var body: some Scene {
            WindowGroup {
                
                CoordinatorView(container: container)   // ✅ pass container
                    .environmentObject(appState)
                    .environmentObject(coordinator)
                    .environmentObject(userVM)
                    .environmentObject(homeVM)
                    .onAppear {
                        // ✅ connect coordinator after everything is alive
                        coordinator.setup(with: appState)
                        
                        // Call the second function for the tap gesture
                        UIApplication.shared.addTapGestureRecognizer()
                    }
                
            }
        }
    }





//struct RahulProjectSwiftUIApp: App {
//    
//    private let container: DependencyContainer
//    
//    //    @StateObject private var userVM = UserViewModel()
//    
//    // 2. Declare StateObjects without initialization
//    @StateObject private var userVM: UserViewModel
//    // @StateObject private var router: Router
//    
//    @StateObject private var router: AppStateRouter
//    
//    // 3. Initialize everything in init()
//    init()
//    {
//        //Lazy Initialization (Recommended)
//        let container = DependencyContainer()
//        self.container = container
//        _userVM = StateObject(wrappedValue: UserViewModel())
//        // _router = StateObject(wrappedValue: Router(container: container))
//        _router = StateObject(wrappedValue: AppStateRouter(container: container))
//    }
//    
//    var body: some Scene {
//        WindowGroup {
//            NavigationStack(path: $router.navPath) {
//                
//                
//                //                ContentView(container: container)
//                //                    .navigationDestination(for: Router.Destination.self) { destination in
//                //
//                //                        router.destination(for: destination)
//                //                    }
//                
//                ContentView(container: container)
//                    .navigationDestination(for: AppRoute.self) { route in
//                        route.destinationView
//                    }
//                
//                
//            }
//            .environmentObject(container.makeAuthViewModel())  // Auth is often app-wide
//            .environmentObject(userVM )
//            .environmentObject(router)
//        }
//    }
//}
