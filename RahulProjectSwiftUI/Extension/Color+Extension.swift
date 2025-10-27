//
//  Color.swift
//  SwiftUIDemo
//
//  Created by Rahul Chaurasia on 27/03/23.
//

import Foundation
import SwiftUI


extension Color {
    
    
    // Use Directly as default color
    //For Use :  Color.appBackground
    
//    static let bg = Color("bg")
//    static let skyblue = Color("skyblue")
    
    
    static let background = Color("bg")
        static let contentBackground = Color("appgray")
        static let primary = Color("skyblue")
        static let blueMenu = Color("bluemenu")
      //  static let accent = Color("appgreen")
        
        // MARK: - Semantic Colors
        static let textPrimary = Color("ptextcolor")
        static let textSecondary = Color("stextcolor")
      //  static let error = Color("error")
    
    static let appblack = Color("ptextcolor")
    static let appBackground = Color("stextcolor")
    
    static let statusBar = Color("blue")
    

    static var secondaryApp: Color {
        return Color(hex: "3369FF")
    }
    
    static var redApp: Color {
        return Color(hex: "F4586C")
    }
    
    
    static var primaryTextx: Color {
        return Color.white
    }
    
    
    static var lightGray: Color {
        return Color(hex: "DADEE3")
    }
    
    static var lightWhite: Color {
        return Color(hex: "EFEFEF")
    }
    
    
    static let appDarkGray = Color.hex("#0C0C0C")
    static let appGray = Color.hex("#0C0C0C").opacity(0.8)
    static let appLightGray = Color.hex("#0C0C0C").opacity(0.4)
    static let appYellow = Color.hex("#FFAC0C")
    
    //Booking
    static let appRed = Color.hex("#F62154")
    static let appBookingBlue = Color.hex("#1874E0")
    
    //Profile
    static let appProfileBlue = Color.hex("#374BFE")
   
    //blue
    
    
    // MARK: - Text Colors
        static let lightText = Color(UIColor.lightText)
        static let darkText = Color(UIColor.darkText)
        static let placeholderText = Color(UIColor.placeholderText)
        // MARK: - Label Colors
        static let label = Color(UIColor.label)
        static let secondaryLabel = Color(UIColor.secondaryLabel)
        static let tertiaryLabel = Color(UIColor.tertiaryLabel)
        static let quaternaryLabel = Color(UIColor.quaternaryLabel)
        // MARK: - Background Colors
        static let systemBackground = Color(UIColor.systemBackground)
        static let secondarySystemBackground = Color(UIColor.secondarySystemBackground)
        static let tertiarySystemBackground = Color(UIColor.tertiarySystemBackground)
        
        // MARK: - Fill Colors
        static let systemFill = Color(UIColor.systemFill)
        static let secondarySystemFill = Color(UIColor.secondarySystemFill)
        static let tertiarySystemFill = Color(UIColor.tertiarySystemFill)
        static let quaternarySystemFill = Color(UIColor.quaternarySystemFill)
        
        // MARK: - Grouped Background Colors
        static let systemGroupedBackground = Color(UIColor.systemGroupedBackground)
        static let secondarySystemGroupedBackground = Color(UIColor.secondarySystemGroupedBackground)
        static let tertiarySystemGroupedBackground = Color(UIColor.tertiarySystemGroupedBackground)
        
        // MARK: - Gray Colors
        static let systemGray = Color(UIColor.systemGray)
        static let systemGray2 = Color(UIColor.systemGray2)
        static let systemGray3 = Color(UIColor.systemGray3)
        static let systemGray4 = Color(UIColor.systemGray4)
        static let systemGray5 = Color(UIColor.systemGray5)
        static let systemGray6 = Color(UIColor.systemGray6)
        
        // MARK: - Other Colors
        static let separator = Color(UIColor.separator)
        static let opaqueSeparator = Color(UIColor.opaqueSeparator)
        static let link = Color(UIColor.link)
        
        // MARK: System Colors
        static let systemBlue = Color(UIColor.systemBlue)
        static let systemPurple = Color(UIColor.systemPurple)
        static let systemGreen = Color(UIColor.systemGreen)
        static let systemYellow = Color(UIColor.systemYellow)
        static let systemOrange = Color(UIColor.systemOrange)
        static let systemPink = Color(UIColor.systemPink)
        static let systemRed = Color(UIColor.systemRed)
        static let systemTeal = Color(UIColor.systemTeal)
        static let systemIndigo = Color(UIColor.systemIndigo)

    
    
}

extension Color {
    static func hex(_ hex: String) -> Color {
        guard let uiColor = UIColor(named: hex) else {
            return Color.red
        }
        return Color(uiColor)
    }
}


//for use:--  Color(UIColor.customdarkGreen)
extension UIColor {
    
    static let customdarkGreen = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)

    static let customlightBlue = #colorLiteral(red: 0.476841867, green: 0.5048075914, blue: 1, alpha: 1)

    static let customred = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)

    static let customyellow = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
    
}
struct CustomColor {
    static let bg = Color("bg")
    static let skyblue = Color("skyblue")
    
    static let appGray = Color("appgray")
    static let appGreen = Color("appgreen")
    
   
    // Add more here...
    
    static let darkGreen = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)

    static let lightBlue = #colorLiteral(red: 0.476841867, green: 0.5048075914, blue: 1, alpha: 1)

    static let redCustom = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)

    static let yellow = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)

}



