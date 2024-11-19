//
//  CircularText.swift
//  SwiftUIDemo
//
//  Created by Rahul Chaurasia on 14/06/23.
//

import Foundation
import SwiftUI

struct CircularText: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            Circle()
                .foregroundColor(.blue.opacity(0.7))
            
            content
                .foregroundColor(.white)
                .font(.system(size: 16 , weight: .semibold))
               
        }
    }
}

