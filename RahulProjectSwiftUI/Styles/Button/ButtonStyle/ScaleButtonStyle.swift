//
//  ScaleButtonStyle.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 11/12/25.
//

import SwiftUI


struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .opacity(configuration.isPressed ? 0.85 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}
