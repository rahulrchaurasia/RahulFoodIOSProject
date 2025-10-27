//
//  LoaderView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 27/10/25.
//

import SwiftUI

struct LoaderView: View {
    let isLoading: Bool
       var message: String? = nil
    
    var body: some View {
            Group {
                if isLoading {
                    ZStack {
                        // Dimmed background
                        Color.black.opacity(0.25)
                            .ignoresSafeArea()
                        
                        // Centered loading indicator
                        VStack(spacing: 12) {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(1.3)
                            
                            if let message = message {
                                Text(message)
                                    .font(.callout)
                                    .foregroundColor(.white)
                                    .padding(.top, 4)
                            }
                        }
                        .padding(.horizontal, 28)
                        .padding(.vertical, 20)
                        .background(.ultraThinMaterial)
                        .cornerRadius(14)
                        .shadow(radius: 10)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .transition(.opacity)
                    .zIndex(10)
                }
            }
            .animation(.easeInOut(duration: 0.25), value: isLoading)
        }
}

#Preview {
    LoaderView(isLoading: true, message: "Fetching your car journeys…")
}
