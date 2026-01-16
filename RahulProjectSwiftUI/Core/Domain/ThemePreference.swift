//
//  ThemePreference.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 01/01/26.
//

import Foundation

import SwiftUI


enum ThemePreference : String ,CaseIterable, Identifiable {
    
    case system
    case light
    case dark
    
    var id: String { rawValue }
    
    var displayName : String {
        switch self {
        case .system:
            return "System Default"
        case .light:
            return "Light"
        case .dark:
            return "Dark"
        }
    }
    
    /// Converts app preference → SwiftUI ColorScheme
    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
    
    var iconName: String {
           switch self {
           case .system: return "gearshape"
           case .light:  return "sun.max.fill"
           case .dark:   return "moon.fill"
           }
       }
}
