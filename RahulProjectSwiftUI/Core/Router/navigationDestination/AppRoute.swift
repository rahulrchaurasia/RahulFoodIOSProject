//
//  AppRoute.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 24/04/25.
//

import Foundation
import SwiftUI

//Mark : Main Root
enum AppRoute: NavigationDestination,Hashable {
    case login
    
    case profile(userProfile: UserProfile)
    
    case home
    
    case forgotPassword
    
    var destinationView: some View {
        switch self {
        case .login: LoginNewView()
            
            
        case .profile(let userProfile): ProfileView(myProfile: userProfile)
            
        case .home: HomeView(repository: DependencyContainer().makeHomeRepository())
            
        case .forgotPassword:
            
            ForgotPasswordView()
            
        }
    }
}



//Mark : AppRoute will be your Screen {Mostly Main Screenn}
typealias AppRouter = TRouter<AppRoute>
