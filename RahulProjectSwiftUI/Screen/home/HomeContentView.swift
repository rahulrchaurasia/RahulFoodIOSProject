//
//  homeContentView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 01/04/25.
//

import SwiftUI

struct HomeContentView: View {
    
        @EnvironmentObject var userVM: UserViewModel
        @EnvironmentObject var router: Router
   // var onLogout: () -> Void
    //UserDefaultsManager.shared.username
    var body: some View {
        VStack {
            Text("Home")
                .font(.title)
                .fontWeight(.heavy)
                .padding()
            
            Text(UserDefaultsManager.shared.loggedInUserName)
                .font(.title)
                .fontWeight(.heavy)
                .padding()
            
            Button {
                
                userVM.logout()
            
                // Navigate to login screen using router
                router.setRoot(_root: .loginModule)
              
                
            } label: {
                AppButton(title: "Log-Out")
            }
            .padding()
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.bg)
    }
}
    
// Preview for HomeContentView
    #Preview {
        HomeContentView()
    }
