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
 
 
 
 For Core Data:
 
 ✅ For Insert in Root View (Very Important)

 Once you inject this at the root:

 .environment(
     \.managedObjectContext,
     container.coreDataManager.context
 )


 SwiftUI automatically provides that context to all child views.

 ✅ In HomeContentView, THIS is the correct and recommended way
 @FetchRequest(
     entity: CategoryEntity.entity(),
     sortDescriptors: [
         NSSortDescriptor(keyPath: \CategoryEntity.strCategory, ascending: true)
     ]
 )
 var savedCategories: FetchedResults<CategoryEntity>
 */



//*************************************************************************

import SwiftUI



    @main
    struct RahulProjectSwiftUIApp: App {
        
        // 1. Keep the Container constant
        private let container: DependencyContainer
        
        
        // 2. Declare StateObjects without initialization
        // 2. Declare StateObjects
        // These will live for the entire lifetime of the app (Global)
        
        @StateObject private var appState : AppState
        @StateObject private var coordinator : AppCoordinator
        @StateObject private var userVM: UserViewModel
        @StateObject private var homeVM : HomeViewModel

        // 3. Initialize everything in init()
        // 3. Initialize with Dependency Injection
        init()
        {
            //Lazy Initialization (Recommended)
            // A. Create the Container first
            let container = DependencyContainer()
            self.container = container
            
            // B. Initialize StateObjects using the Container
           // This is the ONLY way to inject dependencies into root-level StateObjects
            
           
            _appState = StateObject(
                        wrappedValue: AppState(
                            connectivityMonitor: container.connectivityMonitor
                        )
                    )
            _coordinator = StateObject(wrappedValue: AppCoordinator())
            
            // UserVM usually needs a repo, so we grab it from container (assuming you update UserVM init later)
            _userVM = StateObject(wrappedValue: UserViewModel())
          
           
           // ✅ HOME VM: Creating it here makes it the "Single Source of Truth" for the app.
                    // We call 'makeHomeViewModel' because 'App' will hold the single instance.
            _homeVM = StateObject(wrappedValue: container.makeHomeViewModel())
        }
        
        var body: some Scene {
            WindowGroup {
                
                CoordinatorView(container: container)   // ✅ pass container
                    .environment(\.managedObjectContext,
                                         container.coreDataManager.context) // ✅ REQUIRED
                    .environmentObject(appState)
                    .environmentObject(coordinator)
                    .environmentObject(userVM)
                    .environmentObject(homeVM) // ✅ Injected globally
                    .preferredColorScheme(appState.colorScheme)//✅ Color Scheme
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
