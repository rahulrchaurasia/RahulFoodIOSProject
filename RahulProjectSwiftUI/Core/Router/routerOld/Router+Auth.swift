//
//  Router+Auth.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 30/11/24.
//

import Foundation
import SwiftUICore

//Extension for Router


extension Router {
    
     @ViewBuilder
    func destination(for flow : Destination) -> some View {
        
        switch flow {
            
        case .login : LoginNewView()
        case .createAccount(let _name) : createAccountView(name : _name)
        case .forgotPassword : ForgotPasswordView()
        case .emailSent : EmailSentView()
        case .profile(let userProfile ) : ProfileView(myProfile: userProfile)
            
        case .share: NavigationStackBasicView()
            
        case .home:
            
            // Create a new container and use it to make the HomeViewModel
           
            HomeView(repository: container.makeHomeRepository())
            
        }
            
    }
    
}
