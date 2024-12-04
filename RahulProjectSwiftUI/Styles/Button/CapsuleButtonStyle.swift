//
//  CapsuleButtonStyle.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 18/11/24.
//

import SwiftUI


struct CapsuleButtonStyle: ButtonStyle {
    
    var bgColor: Color = .teal
    var textColor: Color = .white
    var hasBorder: Bool = false
    
    func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        configuration.label
            .foregroundColor(textColor)
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                Capsule()
               .fill(bgColor)
               .scaleEffect(configuration.isPressed ? 0.95 : 1) // Scale backgroun
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
            .overlay(
                Capsule()
                    .stroke(Color.gray, lineWidth: hasBorder ? 1 : 0)
                    .scaleEffect(configuration.isPressed ? 0.95 : 1) // Scale border
            )
    }
}
