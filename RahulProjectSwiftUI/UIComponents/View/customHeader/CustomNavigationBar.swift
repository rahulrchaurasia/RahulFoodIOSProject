//
//  CustomNavigationBar.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 18/04/25.
//

import SwiftUI


struct CustomNavigationBar: View {
    let title: String
    let backAction: (() -> Void)?   // optional → controls back button
    
    var backgroundColor: Color = Color(.systemBackground)
    var titleColor: Color = .primary
    var iconColor: Color = .blue
    
    // MARK: - Layout constants
    private let barHeight: CGFloat = 44
    private let iconSize: CGFloat = 20
    private let horizontalPadding: CGFloat = 16
    
    var body: some View {
        HStack {
            // Back Button (only if backAction provided)
            if let backAction = backAction {
                Button(action: backAction) {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .scaledToFit()
                        .frame(width: iconSize, height: iconSize)
                        .foregroundColor(iconColor)
                }
                .padding(.leading, horizontalPadding)
            } else {
                Spacer()
                    .frame(width: iconSize + horizontalPadding)
            }
            
            Spacer()
            
            // Title
            Text(title)
                .font(.headline.weight(.semibold))
                .foregroundColor(titleColor)
                .lineLimit(1)
                .minimumScaleFactor(0.9)
            
            Spacer()
            
            // Balance spacer
            Spacer()
                .frame(width: iconSize + horizontalPadding)
        }
        .frame(height: barHeight)
        .background(backgroundColor) // ✅ no ignoresSafeArea
        .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 1)
    }
}



#Preview {
    VStack(spacing: 0) {
        CustomNavigationBar(
            title: "Settings",
          
            backAction: {
                print("Back tapped")
            }
        )
        Spacer()
    }
}
