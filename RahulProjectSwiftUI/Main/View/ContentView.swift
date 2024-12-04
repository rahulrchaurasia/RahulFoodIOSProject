//
//  ContentView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 13/11/24.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var authVM : AuthViewModel
    var body: some View {
        
        LoginView()
        //HomeView()
            .environmentObject(authVM)
        
    }
}

#Preview {
    ContentView()
}
