//
//  PermissionOptionButton.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 11/12/25.
//

import SwiftUI


struct PermissionOptionButton: View {
    let icon: String
    let title: String
    let tint: Color
    let action: () -> Void

    var body: some View {
        Button(action: {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            action()
        }) {
            HStack(spacing: 16) {
                
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(tint)

                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)

                Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(tint.opacity(0.4), lineWidth: 1)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(uiColor: .systemGray6))
                    )
                    .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
            )
        }
        .buttonStyle(ScaleButtonStyle())  // Press animation
    }
}
