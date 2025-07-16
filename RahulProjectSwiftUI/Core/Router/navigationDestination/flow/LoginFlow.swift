//
//  LoginFlow.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 26/04/25.
//

import Foundation
import SwiftUI

enum LoginFlow : NavigationDestination, Hashable {
    
    case createAccount(name: String)
    case forgotPassword
    case emailSent
    case share
   
    
    var destinationView: some View{
        
        switch self {
            
        case .createAccount(let name): createAccountView(name: name)
            
        case .forgotPassword:
            
            ForgotPasswordView()
            
        case .emailSent:
            
            EmailSentView()
            
        case .share: NavigationStackBasicView()
            
        }
     
    }
    
    
}

typealias LoginFlowRouter = TRouter<LoginFlow>
