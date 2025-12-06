//
//  DateInputModifier.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 19/11/25.
//

import Foundation

import SwiftUI

// Custom modifier for date formatting
struct DateInputModifier: ViewModifier {
    @Binding var text: String
    
    func body(content: Content) -> some View {
        content
            .keyboardType(.numbersAndPunctuation)
            .onChange(of: text) { newValue in
                text = formatDateString(newValue)
            }
    }
    
    private func formatDateString(_ input: String) -> String {
        let numbers = input.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        
        guard !numbers.isEmpty else { return "" }
        
        var result = ""
        
        for (index, character) in numbers.enumerated() {
            if index == 2 || index == 4 {
                result += "-"
            }
            result.append(character)
            
            if index >= 7 { break } // DD-MM-YYYY has 8 digits
        }
        
        return result
    }
}

