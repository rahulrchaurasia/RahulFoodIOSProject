//
//  Router.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 29/11/24.
//

import Foundation
import SwiftUI


final class Router : ObservableObject {
    
    @Published var navPath = NavigationPath()
    @Published var stacks :  [ AuthFlow] = []
    
    enum AuthFlow : Hashable, Codable{
        
        case login
        case createAccount(name : String)
        case profile( userProfile :UserProfile)
        case forgotPassword
        case emailSent
        
    }
    
    func navigate(to destination: AuthFlow) {
        
        navPath.append(destination)
        stacks.append(destination)
    }
    
    
    func navigateBack(){
        navPath.removeLast()
        stacks.removeLast()
    }
    
    func navigateToRoot(){
       
        navPath.removeLast(navPath.count )
        stacks.removeAll()
    }
    
    func navigateBack1(to target : AuthFlow){
        
        guard !stacks.isEmpty else { return }
        
        while let last = stacks.last ,   last != target {
            navPath.removeLast()
            stacks.removeLast()
        }
    }
    
    
    
    func navigateBack(to target: AuthFlow) {
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
}
