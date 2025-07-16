//
//  Router.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 29/11/24.
//

import Foundation
import SwiftUI


enum AuthState1 : String {
    
    case onboardingModule
    case loginModule
    case dashboardModule // main(tab: MainTab)
}


final class Router : ObservableObject {
    
     let container: DependencyContainer    // expecting DependencyContainer
    @Published var navPath = NavigationPath()
    @Published var stacks :  [ Destination] = []
    
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false

    // Single AppStorage for persistence
    @AppStorage("authRoot") private var storedRoot: String = AuthState.onboardingModule.rawValue

        // Expose `root` via computed property for centralized access
//        var root: AuthState {
//            get { AuthState(rawValue: storedRoot) ?? .onboardingModule }
//            set { storedRoot = newValue.rawValue }
//        }
    
    init(container: DependencyContainer) {
            self.container = container
    }
    var root: AuthState {
        get {
            
            // Check if onboarding has been seen; otherwise default to onboarding
            if !hasSeenOnboarding {
                return .onboardingModule // Show onboarding if it hasn't been completed
            } else if !isUserLoggedIn() {
                return .loginModule // Show login if the user is not logged in
            } else {
                return .dashboardModule // Show home if the user is logged in
            }
        }
        set { storedRoot = newValue.rawValue }
    }
    
    enum Destination : Hashable, Codable{
        
        case login
        case createAccount(name : String)
        case profile( userProfile :UserProfile)
        case forgotPassword
        case emailSent
        case home
        case share
        
    }
    
    
  
    func navigate(to destination: Destination) {
        
        navPath.append(destination)
        stacks.append(destination)
    }
    
    
    func navigateBack(){
        
        guard !navPath.isEmpty else { return }
        navPath.removeLast()
        stacks.removeLast()
    }
    
    func navigateToRoot(){
       
        navPath.removeLast(navPath.count )
        stacks.removeAll()
    }
    
    func navigateBack1(to target : Destination){
        
        guard !stacks.isEmpty else { return }
        
        while let last = stacks.last ,   last != target {
            navPath.removeLast()
            stacks.removeLast()
        }
    }
    
    
    
    func navigateBack(to target: Destination) {
        // Find the index of the target in the stack
        guard let targetIndex = stacks.lastIndex(of: target) else {
            print("Target view not found in navigation stack")
            return
        }
        
        // Calculate how many items to remove
        let itemsToRemove = stacks.count - (targetIndex + 1)
        
        // Remove items from both stacks
        if itemsToRemove > 0 {
            navPath.removeLast(itemsToRemove)
            stacks.removeLast(itemsToRemove)
        }
    }
    
    func setRoot(_root : AuthState){
        
        self.root = _root
        navigateToRoot()
    }
    
    private func isUserLoggedIn() -> Bool {
        // Replace this with your actual login state check logic
        return UserDefaults.standard.bool(forKey: "isLoggedIn")
    }
}
