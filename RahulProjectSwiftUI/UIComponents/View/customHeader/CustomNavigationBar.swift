//
//  CustomNavigationBar.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 18/04/25.
//

import SwiftUI

struct CustomNavigationBar: View {
    let title: String
    let showBackButton: Bool
    let backAction: () -> Void
    
    var body: some View {
        HStack {
            if showBackButton {
                Button(action: backAction) {
                    Image(systemName: "chevron.left")
                        .imageScale(.large)
                        .foregroundColor(.blue)
                }
                .padding(.leading, 16)
            } else {
                // Add spacer to maintain alignment when no back button
                Spacer()
                    .frame(width: 40)
                    .padding(.leading, 16)
            }
            
            Spacer()
            
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
            
            Spacer()
            
            // Balance the layout
            Spacer()
                .frame(width: 40)
                .padding(.trailing, 16)
        }
        .frame(height: 44)
        .background(Color(.systemBackground))
    }
}

#Preview {
    VStack(spacing: 0) {
        CustomNavigationBar(
            title: "Settings",
            showBackButton: true,
            backAction: {
                print("Back tapped")
            }
        )
        Spacer()
    }
}
