//
//  ScreenMetrics.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 07/04/25.
//

import Foundation

import SwiftUI
import UIKit

// Utility struct for screen measurements and safe area values
struct ScreenMetrics {
    // Screen dimensions
    static var width: CGFloat {
        UIScreen.main.bounds.width
    }
    
    static var height: CGFloat {
        UIScreen.main.bounds.height
    }
    
    // Calculate a percentage of screen width
    static func widthPercent(_ percent: CGFloat) -> CGFloat {
        return width * percent
    }
    
    // Calculate a percentage of screen height
    static func heightPercent(_ percent: CGFloat) -> CGFloat {
        return height * percent
    }
    
    // Safe area insets
    static var safeArea: UIEdgeInsets {
        let scene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
        return scene?.windows.first?.safeAreaInsets ?? .zero
    }
    
    static var topInset: CGFloat {
        safeArea.top
    }
    
    static var bottomInset: CGFloat {
        safeArea.bottom
    }
    
    static var leadingInset: CGFloat {
        safeArea.left
    }
    
    static var trailingInset: CGFloat {
        safeArea.right
    }
    
    static var horizontalInsets: CGFloat {
        safeArea.left + safeArea.right
    }
    
    static var verticalInsets: CGFloat {
        safeArea.top + safeArea.bottom
    }
    
    // Device type checks
    static var isPhone: Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }
    
    static var isPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    // Orientation check
    static var isLandscape: Bool {
        width > height
    }
}
/*
 
 Basic Usage in a View
 Text("Responsive Title")
                 .font(.appTitle)
                 .frame(width: ScreenMetrics.widthPercent(0.9))
   
 
 Custom Layout Component Example
 struct ResponsiveCardView: View {
     let title: String
     let description: String
     
     var body: some View {
         VStack(alignment: .leading) {
             Text(title)
                 .font(.appMedium)
                 .padding(.bottom, 8)
             
             Text(description)
                 .font(.appSmallRegular)
             
             Button("Learn More") {
                 // Action
             }
             .padding(.top, 12)
         }
         .padding(16)
         .frame(width: ScreenMetrics.isPhone ?
                ScreenMetrics.widthPercent(0.9) :
                ScreenMetrics.widthPercent(0.6))
         .background(Color.white)
         .cornerRadius(12)
         .shadow(radius: 4)
     }
 }
 
 
 */
