//
//  UIExtension.swift
//  SwiftUIDemo
//
//  Created by Rahul Chaurasia on 14/11/23.
//

import Foundation

//
//  UIExtension.swift
//  Trackizer
//
//  Created by CodeForAny on 11/07/23.
//

import SwiftUI

enum Inter: String {
        case regular = "inter_regular"
       case medium = "inter_semibold"

       case bold = "inter_bold"
}



extension Font {
    
   
    static func customfont(_ font: Inter, fontSize: CGFloat) -> Font {
        custom(font.rawValue, size: fontSize)
        
    }
    
    static let appHeader = Font.custom(Inter.bold.rawValue, size: 28)
    static let appTitle = Font.custom(Inter.bold.rawValue, size: 24)
    static let appLarge = Font.custom(Inter.bold.rawValue, size: 20)
    static let appMedium = Font.custom(Inter.medium.rawValue, size: 16)
    static let appMediumRegular = Font.custom(Inter.regular.rawValue, size: 16)
    static let appSmall = Font.custom(Inter.medium.rawValue, size: 14)
    static let appSmallRegular = Font.custom(Inter.regular.rawValue, size: 14)
}
extension CGFloat {
    
    static var screenWidth: Double {
        return UIScreen.main.bounds.size.width
    }
    
    static var screenHeight: Double {
        return UIScreen.main.bounds.size.height
    }
    
    static func widthPer(per: Double) -> Double {
        return screenWidth * per
    }
    
    static func heightPer(per: Double) -> Double {
        return screenHeight * per
    }
    
    
    static func getSafeArea() -> UIEdgeInsets {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow }) else {
            return .zero
        }
        return window.safeAreaInsets
    }
    static func getSafeArea2() -> UIEdgeInsets {
        
        guard let screen = UIApplication.shared.connectedScenes.first as?
                UIWindowScene else {
            return .zero
        }
        
        guard let safeArea = screen.windows.first?.safeAreaInsets else {
            return .zero
        }
        
        return safeArea
        
    }
   
    static var topInsets: CGFloat {
          getSafeArea().top
      }

      static var bottomInsets: CGFloat {
          getSafeArea().bottom
      }
    
    static var horizontalInsets: CGFloat {
        let insets = getSafeArea()
        return insets.left + insets.right
    }

    static var verticalInsets: CGFloat {
        let insets = getSafeArea()
        return insets.top + insets.bottom
    }
    
//    static var topInsets: Double {
//        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
//            return Double(scene.windows.first?.safeAreaInsets.top ?? 50)
//        }
//        return 0.0
//        
//    }
//    
//    
//    static var bottomInsets: Double {
//        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
//            return Double(scene.windows.first?.safeAreaInsets.bottom ?? 50)
//        }
//        return 0.0
//    }
    
//    static var horizontalInsets: Double {
//        
//        
//        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
//            return Double(scene.windows.first?.safeAreaInsets.left ?? 8 + (scene.windows.first?.safeAreaInsets.right ?? 8) )
//        }
//        return 0.0
//    }
//    
//    static var verticalInsets: Double {
//        
//        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
//            return Double(scene.windows.first?.safeAreaInsets.top ?? 10 + (scene.windows.first?.safeAreaInsets.bottom ?? 10) )
//        }
//        return 0.0
//    }
    
}

extension Color {
    
    //#673AB7
    
    static var toolBar: Color {
        return Color(hex: "#283593")
    }
    static var primaryApp: Color {
        return Color(hex: "53B175")
    }
    
    
    static var primaryText: Color {
        return Color(hex: "030303")
    }
    
    static var secondaryText: Color {
        return Color(hex: "828282")
    }
    
    static var textTitle: Color {
        return Color(hex: "7C7C7C")
    }
    
    static var placeholder: Color {
        return Color(hex: "B1B1B1")
    }
    
    static var darkGray: Color {
        return Color(hex: "4C4F4D")
    }
//    static var primary: Color {
//        return Color(hex: "5E00F5")
//    }
    static var primary500: Color {
        return Color(hex: "7722FF")
    }
    static var primary20: Color {
        return Color(hex: "924EFF")
    }
    static var primary10: Color {
        return Color(hex: "AD7BFF")
    }
    static var primary5: Color {
        return Color(hex: "C9A7FF")
    }
    static var primary0: Color {
        return Color(hex: "E4D3FF")
    }
    
    static var secondaryC: Color {
        return Color(hex: "FF7966")
    }
    
    static var secondary50: Color {
        return Color(hex: "FFA699")
    }
    
    static var secondary0: Color {
        return Color(hex: "FFD2CC")
    }
    
    static var secondaryG: Color {
        return Color(hex: "00FAD9")
    }
    
    static var secondaryG50: Color {
        return Color(hex: "7DFFEE")
    }
    
    static var grayC: Color {
        return Color(hex: "0E0E12")
    }
    static var gray80: Color {
        return Color(hex: "1C1C23")
    }
    static var gray70: Color {
        return Color(hex: "353542")
    }
    static var gray60: Color {
        return Color(hex: "4E4E61")
    }
    static var gray50: Color {
        return Color(hex: "666680")
    }
    static var gray40: Color {
        return Color(hex: "83839C")
    }
    static var gray30: Color {
        return Color(hex: "A2A2B5")
    }
    static var gray20: Color {
        return Color(hex: "C1C1CD")
    }
    
    static var gray10: Color {
        return Color(hex: "E0E0E6")
    }
    
   
    
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
            case 3: // RGB(12 -bit)
                (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
            case 6: // RGB (24-bit)
                (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
            case 8: // ARGB (32-bit)
                (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
            default:
                (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}


struct ShowButton: ViewModifier {
    @Binding var isShow: Bool
    
    public func body(content: Content) -> some View {
        
        HStack {
            content
            Button {
                isShow.toggle()
            } label: {
                Image(systemName: !isShow ? "eye.fill" : "eye.slash.fill" )
                    .foregroundColor(.textTitle)
            }

        }
    }
}


