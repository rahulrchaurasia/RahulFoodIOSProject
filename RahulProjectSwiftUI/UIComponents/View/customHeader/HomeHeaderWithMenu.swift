//
//  HomeHeaderWithMenu.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 26/09/25.
//

import SwiftUI

struct HomeHeaderWithMenu: View {
    // MARK: - Properties
    let title: String
    let showMenuIcon: Bool
    var backgroundColor: Color = .toolBar // fallback color from Assets/extension
    let menuAction: () -> Void
    
    // MARK: - Constants
    private let iconSize: CGFloat = 28
    private let horizontalPadding: CGFloat = 8
    
    // MARK: - Body
    var body: some View {
        ZStack {
            // Background that fills into safe area
            backgroundColor
                .ignoresSafeArea(edges: .top)
            
            HStack {
                if showMenuIcon {
                    // Menu Button
                    Button(action: menuAction) {
                        Image(systemName: "line.horizontal.3")
                            .resizable()
                            .scaledToFit()
                            .frame(width: iconSize, height: iconSize)
                            .padding(10) // ✅ bigger tap area
                            .contentShape(Rectangle())
                    }
                    .padding(.leading, horizontalPadding)
                } else {
                    // Keep space so title stays centered
                    Spacer()
                        .frame(width: iconSize + horizontalPadding + 20)
                }

                Spacer()
                
                // Title
                Text(title)
                    .font(.title2.weight(.semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                
                Spacer()
                
                // Right side empty (reserved for future actions)
                Spacer().frame(width: iconSize + horizontalPadding)
            }
            .foregroundColor(.white)
            .padding(.horizontal)
        }
        .frame(height: 44 )
        .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 1)
    }
}


#Preview {
   
    
    VStack {
        HomeHeaderWithMenu(title: "Home", showMenuIcon: false) {
                print("Menu tapped")
            }
            
        HomeHeaderWithMenu(title: "Transactions", showMenuIcon: true, backgroundColor: .purple) {
                print("Menu tapped")
            }
        }
        .background(Color.bg)
}
