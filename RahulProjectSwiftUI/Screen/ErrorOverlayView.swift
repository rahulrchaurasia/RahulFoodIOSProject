//
//  ErrorOverlayView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 01/04/25.
//

import Foundation
import SwiftUICore
import SwiftUI

// MARK: - Core/Components/ErrorOverlayView.swift
struct ErrorOverlayView: View {
    let errorMessage: String
    let onDismiss: () -> Void
    let hasData: Bool
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.title)
                        .foregroundColor(.white)
                    
                    Text(errorMessage)
                        .font(.headline)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Button("Dismiss") {
                        onDismiss()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(Color.white)
                    .foregroundColor(.red)
                    .cornerRadius(8)
                }
                .padding()
                .background(Color.red.opacity(0.8))
                .cornerRadius(12)
                .shadow(radius: 10)
                
                Spacer()
            }
            
            Spacer()
        }
        .transition(.opacity)
        .zIndex(1)
    }
}


