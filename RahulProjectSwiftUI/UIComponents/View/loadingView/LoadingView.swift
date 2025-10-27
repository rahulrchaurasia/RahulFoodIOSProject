//
//  LoadingView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 23/12/24.
//

import SwiftUI

struct LoadingView: View {
    
    var isLoading: Bool
    var size: CGFloat = 2
    var color: Color = .blue
    var body: some View {
        if isLoading {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: color))
                .scaleEffect(size)
        }
    }
}

#Preview {
    LoadingView(isLoading: true)
        .previewLayout(.sizeThatFits)
                        .padding()
                        .previewDisplayName("Loading View - Blue")
}
