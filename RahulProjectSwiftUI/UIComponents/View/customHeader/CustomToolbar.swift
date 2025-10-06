//
//  CustomOrderToolbar.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 29/09/25.
//

import SwiftUICore
import SwiftUI




struct CustomToolbar: View {
    var title: String
    var backAction: (() -> Void)? = nil
    var closeAction: (() -> Void)? = nil
    var backgroundColor: Color?
    var tintColor: Color = .black   // ✅ new
    private let iconSize: CGFloat = 20
    
    var body: some View {
        ZStack {
            // Use .ultraThinMaterial for a more standard translucent effect
            (backgroundColor ?? Color.clear)
                .background(.ultraThinMaterial)
                .ignoresSafeArea(edges: .top)
            
            HStack {
                // ✅ --- THE FIX IS HERE ---
                // Use 'if let' to safely unwrap the optional action
                if let backAction = backAction {
                    Button(action: backAction) { // Now you can pass it directly
                        Image(systemName: "arrow.backward")
                            .resizable()
                            .scaledToFit()
                            .frame(width: iconSize, height: iconSize)
                            .foregroundColor(tintColor) // Ensure icon is visible in light/dark mode
                    }
                    // ✅ APPLY THE FIX HERE
                      .buttonStyle(.plain)
                } else {
                    // This provides an invisible spacer to keep the title centered
                    Spacer().frame(width: iconSize)
                }
                
                Spacer()
                
                Text(title)
                    .font(.headline)
                
                Spacer()
                
                // ✅ Applying the same safe pattern to the close button
                if let closeAction = closeAction {
                    Button(action: closeAction) {
                        Image(systemName: "xmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: iconSize, height: iconSize)
                            .foregroundColor(tintColor)
                    }
                    // ✅ APPLY THE FIX HERE
                       .buttonStyle(.plain)
                } else {
                    Spacer().frame(width: iconSize)
                }
            }
            .padding()
        }
        .frame(height: 44)
        .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 1)
    }
}


#Preview {
    VStack(spacing: 0) {
        CustomToolbar(title: "Order Summary", backAction: {}, closeAction: {}, backgroundColor: .systemGray6)
        Spacer()
    }
}
