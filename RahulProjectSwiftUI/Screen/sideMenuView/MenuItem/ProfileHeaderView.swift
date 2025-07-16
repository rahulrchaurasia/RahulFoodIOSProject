//
//  ProfileHeaderView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 15/04/25.
//

import SwiftUI

struct ProfileHeaderView: View {
    
    let userName : String
    let userEmail : String
    let userMobile : String
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            
            
            HStack(spacing: 12) {
                // Circular profile image
                
                
                ZStack{
                    
                    Circle()
                        .fill(Color.gray.opacity(0.7))
                        .frame(width: 60, height: 60)
                    
                    Text("R")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
                //user details
                VStack(alignment: .leading, spacing: 4) {
                    Text(userName)
                        .font(.headline)
                        .foregroundStyle(Color.black)
                    Text(userEmail)
                        .font(.subheadline)
                        .foregroundColor(.black.opacity(0.8))
                    
                    Text(userMobile)
                        .font(.caption)
                        .foregroundColor(.black.opacity(0.8))
                        .padding(.top, 4)
                }
            }
          
            
            Divider()
                .foregroundColor(.white.opacity(0.4))
                .frame(width: 2)
                .padding(.top, 4)
        }
        .padding(.top, CGFloat.topInsets + 10)
               .padding(.horizontal, 20)
               .padding(.bottom, 20)
    }
}

#Preview {
    ProfileHeaderView(userName: "Ravi Test", userEmail: "testUser@gmail.com", userMobile: "989997700")
}
