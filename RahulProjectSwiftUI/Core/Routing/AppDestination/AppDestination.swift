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

/* **************** .safeAreaInset ********************************
 
 .safeAreaInset automatically handles the safe area padding and pushes your content down below the notch/status bar.
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


extension AppDestination {
    func isSameCase(as other: AppDestination) -> Bool {
        switch (self, other) {

        // Onboarding
        case (.onboarding, .onboarding): return true

        // Login
        case (.login, .login): return true

        // HomeFlow cases
        case (.home(let lhsFlow), .home(let rhsFlow)):
            switch (lhsFlow, rhsFlow) {
            case (.home, .home): return true
            case (.mealList, .mealList): return true
            case (.mealDetail, .mealDetail): return true
            case (.order, .order): return true
            default: return false
            }
        
        default:
            return false
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
    case login, forgotPassword, signUp,registerUser

    @MainActor @ViewBuilder
    func destinationView(container: DependencyContainer) -> some View {
        switch self {
        case .login: LoginNewView()
        case .forgotPassword: ForgotPasswordView()
        case .signUp: createAccountView()
        case .registerUser : RegisterView(viewModel: container.makeLoginViewModel())
        }
    }
}

enum HomeFlow: Hashable {
    
    
    case home
        case profile
        case insurance(type: InsuranceType)
        case mealList(categoryName: String)
        case mealDetail(mealId: String)
        case order(mealId: String, mealName: String)
        case setting
        case agent
    
    @MainActor @ViewBuilder
    func destinationView(container: DependencyContainer) -> some View {
        switch self {
        case .home:
            
            
           // HomeView(viewModel: container.makeHomeViewModel())
            HomeView(viewModel: container.makeCarViewModel())
           
        case  .profile:
            
            ProfileView(profileVM: container.makeProfileViewModel())
        
        case .insurance(let type) :
            
            InsuranceListView(
                insuranceViewModel: container.makeInsuranceViewModel(for:  type),
                container: container)
            
    
        case .mealDetail(let mealId):
            
            MealDetailScreen(mealId: mealId)
            
        case .mealList( let categoryName) :
            
            
            MealGridView(  category: categoryName)
            
        case .order(let  mealId ,  let mealName) :
            
            OrderScreen(mealId: mealId, mealName: mealName )
            
          
        case .agent:
            
            AgentListView(agentViewModel: container.makeAgentViewModel())
            
        case .setting:
            
            AppearanceSettingsView()
       
      
        }
        
        
   
        
        //Car Journey
        
        
    }
}


