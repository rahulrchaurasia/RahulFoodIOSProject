//
//  AuthVM.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 21/11/24.
//

import Foundation

@MainActor
final class AuthViewModel : ObservableObject {
    
    
    @Published var isLoggedIn : Bool = false
    @Published var isError : Bool = false
    
    init(){
        
    }
}
