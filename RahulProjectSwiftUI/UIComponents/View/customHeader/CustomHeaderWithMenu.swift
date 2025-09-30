//
//  CustomHeaderWithMenu.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 18/04/25.
//



import SwiftUI

struct CustomHeaderWithMenu: View {
    // MARK: - Properties
    let title: String
    let dismissAction: (() -> Void)?
    let menuAction: (() -> Void)?
    let homeAction: (() -> Void)?
    var backgroundColor: Color? // Optional background color
    
    // MARK: - Constants
    private let iconSize: CGFloat = 20
    private let horizontalPadding: CGFloat = 8
    private let backButtonTrailingPadding: CGFloat = 20
    private let trailingIconSpacing: CGFloat = 16 // Standardized spacing between trailing icons
    
    // MARK: - Body
    var body: some View {
        ZStack {
            // Background that fills safe area
            (backgroundColor ?? Color.toolBar)
                .ignoresSafeArea(edges: .top)
            
            HStack(alignment: .center, spacing: 0) {
                // Back Button
                if let dismissAction = dismissAction {
                    Button(action: dismissAction) {
                        Image(systemName: "arrow.backward")
                            .resizable()
                            .scaledToFit()
                            .frame(width: iconSize, height: iconSize)
                    }
                    .padding(.leading, horizontalPadding)
                    .padding(.trailing, backButtonTrailingPadding)
                    .accessibilityLabel("Back")
                } else {
                    Spacer()
                        .frame(width: iconSize + horizontalPadding + backButtonTrailingPadding)
                }
                
                // Title
                Text(title)
                    .font(.title2.weight(.semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                
                Spacer()
                
                // Trailing buttons with standardized spacing
                HStack(spacing: trailingIconSpacing) {
                    if let menuAction = menuAction {
                        Button(action: menuAction) {
                            Image(systemName: "square.and.arrow.up")
                                .resizable()
                                .scaledToFit()
                                .frame(width: iconSize, height: iconSize)
                                .accessibilityLabel("Share")
                        }
                    }
                    
                    if let homeAction = homeAction {
                        Button(action: homeAction) {
                            Image(systemName: "house")
                                .resizable()
                                .scaledToFit()
                                .frame(width: iconSize, height: iconSize)
                                .accessibilityLabel("Home")
                        }
                    }
                }
                .padding(.trailing, horizontalPadding)
            }
            .foregroundColor(.white)
           
            .padding(.horizontal)
        }
        .frame(height: 44 )
        .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 1)
    }
}


// MARK: - Preview
struct CustomHeaderWithMenu_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // All options
            CustomHeaderWithMenu(
                title: "Complete Header",
                dismissAction: {},
                menuAction: {},
                homeAction: {}
            )
            .previewDisplayName("Complete Header")
            
            // No dismiss action
            CustomHeaderWithMenu(
                title: "No Back Button and Home",
                dismissAction: nil,
                menuAction: {},
                homeAction: nil
            )
           
            .previewDisplayName("No Back Button")
            
            // Only title and back button
            CustomHeaderWithMenu(
                title: "Minimal Header",
                dismissAction: {},
                menuAction: nil,
                homeAction: nil
            )
            .previewDisplayName("Minimal Header")
            
            // Long title test
            CustomHeaderWithMenu(
                title: "This is a very long title that should truncate",
                dismissAction: {},
                menuAction: {},
                homeAction: {}
            )
            .previewDisplayName("Long Title")
            
            // Custom background color
            CustomHeaderWithMenu(
                title: "Custom Background",
                dismissAction: {},
                menuAction: {},
                homeAction: {},
                backgroundColor: .purple
            )
            .previewDisplayName("Custom Background")
        }
        .previewLayout(.sizeThatFits)
        .background(Color.bg)
    }
}


//#Preview {
//    CustomHeaderWithMenu()
//}
