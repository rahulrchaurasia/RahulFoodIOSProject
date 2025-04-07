//
//  ResponsiveFrameModifier.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 07/04/25.
//

import Foundation
import SwiftUICore

struct ResponsiveFrameModifier: ViewModifier {
    let widthPercent: CGFloat
    let alignment: Alignment
    
    func body(content: Content) -> some View {
        content
            .frame(width: ScreenMetrics.widthPercent(widthPercent), alignment: alignment)
    }
}

extension View {
    func responsiveWidth(_ percent: CGFloat, alignment: Alignment = .center) -> some View {
        self.modifier(ResponsiveFrameModifier(widthPercent: percent, alignment: alignment))
    }
}

// Usage:
// Text("Responsive text").responsiveWidth(0.8)
