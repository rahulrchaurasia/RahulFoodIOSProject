//
//  RahulProjectSwiftUIApp.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 13/11/24.
//

import SwiftUI



@main
struct RahulProjectSwiftUIApp: App {
    
    private let container: DependencyContainer
    
    
    // 2. Declare StateObjects without initialization
    @StateObject private var userVM: UserViewModel

    @StateObject private var router: AppStateRouter
    
    // 3. Initialize everything in init()
    init()
    {
        //Lazy Initialization (Recommended)
        let container = DependencyContainer()
        self.container = container
        _userVM = StateObject(wrappedValue: UserViewModel())
        _router = StateObject(wrappedValue: AppStateRouter(container: container))
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.navPath) {
                           ContentView(container: container)
                       }
                       .environmentObject(container.makeAuthViewModel())
                       .environmentObject(userVM)
                       .environmentObject(router)
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
