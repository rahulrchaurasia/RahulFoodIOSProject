//
//  AppDestination.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 09/09/25.
//

import Foundation
import SwiftUI

/*
 @MainActor :
 By marking destinationView with @MainActor, you’re telling Swift that this function can only run on the main thread.

 This prevents you from accidentally calling it from a background thread (which would crash or cause UI glitches).
 
 Using @MainActor for destinationView is best practice because it’s a UI-building function.

 */
enum AppDestination : Hashable,Equatable {
    
    case onboarding(OnboardingFlow)
    case login(LoginFlow)
    case home(HomeFlow)
    
    @MainActor @ViewBuilder
        func destinationView(container: DependencyContainer) -> some View {
            switch self {
            case .onboarding(let flow):
                flow.destinationView(container: container)
            case .login(let flow):
                flow.destinationView(container: container)
            case .home(let flow):
                flow.destinationView(container: container)
            }
        }
}

enum OnboardingFlow: Hashable {
    case  onBoardings

    @MainActor @ViewBuilder
    func destinationView(container: DependencyContainer) -> some View {
        switch self {
          case .onBoardings: OnboardingView()
        }
    }
}

enum LoginFlow: Hashable {
    case login, forgotPassword, signUp

    @MainActor @ViewBuilder
    func destinationView(container: DependencyContainer) -> some View {
        switch self {
        case .login: LoginNewView()
        case .forgotPassword: ForgotPasswordView()
        case .signUp: createAccountView()
        }
    }
}

enum HomeFlow: Hashable {
    case home,
         mealList( categoryName : String),
         mealDetail(mealId: String)
    
    @MainActor @ViewBuilder
    func destinationView(container: DependencyContainer) -> some View {
        switch self {
        case .home:
           
            HomeView()
           
            
        case .mealDetail(let mealId):
            
           MealDetailScreen(mealId: mealId)
            
        case .mealList( let categoryName) :
            
           
        
            VStack(spacing: 0) {
                        CustomHeader(
                            title: categoryName,
                            dismissAction: {  }
                        )
                       MealGridView(  category: categoryName)
                    }
        }
    }
}


