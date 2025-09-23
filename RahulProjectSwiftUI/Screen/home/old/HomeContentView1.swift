//
//  HomeContentView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 07/04/25.
//

import SwiftUI

import SwiftUI

//Mark Add a Mask at bottom for handling scrollview above bottomView
/*
 // Add bottom padding that matches navigation height
Spacer().frame(height: bottomNavHeight + bottomPadding + CGFloat.bottomInsets)
 */
struct HomeContentView1: View {
    @EnvironmentObject var userVM: UserViewModel
   // @EnvironmentObject var router: AppStateRouter
    
    // Constants for navigation height
    private let bottomNavHeight: CGFloat = 60
    private let bottomPadding: CGFloat = 8
    
    var body: some View {
        // Main container with background color extending to edges
        ZStack(alignment: .top) {
            // Background that extends all the way
            Color.bg
                .ignoresSafeArea()
            
            // Scrollable content with clipping at bottom
            ScrollView {
                VStack(spacing: 16) {
                    Text("Home")
                        .font(.title)
                        .fontWeight(.heavy)
                        .padding(.top)

                    Text(UserDefaultsManager.shared.loggedInUserName)
                        .font(.title)
                        .fontWeight(.heavy)

                    Button {
                      //  userVM.logout()
                       
                       // router.setRoot(.loginModule)
                    } label: {
                        AppButton(title: "Log-Out")
                    }

                    Text("text data\ndata edwdw dewdwdwbdwdw edwedwe")
                        .font(.body)
                        .fontWeight(.heavy)
                        .multilineTextAlignment(.center)
                        .padding()

                    Spacer().frame(height: 200)

                    Text("text2 data\ndata edwdw dewdwdwbdwdw edwedwe")
                        .multilineTextAlignment(.leading)
                    
                    Spacer().frame(height: 50)
                    
                    Text("text3 data\ndata edwdw dewdwdwbdwdw edwedwe")
                        .multilineTextAlignment(.leading)
                    
                    Spacer().frame(height: 50)
                    
                    Text("text4 data\ndata edwdw dewdwdwbdwdw edwedwe")
                        .multilineTextAlignment(.leading)
                    
                    // Add bottom padding that matches navigation height
                    Spacer().frame(height: bottomNavHeight + bottomPadding + CGFloat.bottomInsets)
                }
                .frame(maxWidth: .infinity)
                .padding()
            }
            
            // Bottom mask to hide scrolled content
            VStack {
                Spacer()
                Rectangle()
                    .fill(Color.bg)
                    .frame(height: bottomNavHeight + bottomPadding + CGFloat.bottomInsets)
                    .allowsHitTesting(false) // Let touches pass through
            }
            .ignoresSafeArea()
        }
    }
}


    
// Preview for HomeContentView
    #Preview {
        HomeContentView1()
    }
