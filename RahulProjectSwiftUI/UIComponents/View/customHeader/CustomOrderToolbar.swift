//
//  CustomOrderToolbar.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 29/09/25.
//

import SwiftUICore
import SwiftUI


struct CustomOrderToolbar: View {
    var title: String
    var backAction: () -> Void
    var closeAction: () -> Void
    var backgroundColor: Color? // Optional background color
   
    
    private let iconSize: CGFloat = 20
    var body: some View {
        
        ZStack {
            
            (backgroundColor ?? Color(.systemBackground))
                .blur(radius: 0) // or use .regularMaterial for translucent effect
                .ignoresSafeArea(edges: .top)
            
            HStack {
                Button(action: backAction) {
                    Image(systemName: "arrow.backward")
                        .resizable()
                        .scaledToFit()
                        .frame(width: iconSize, height: iconSize)
                }
                
                Spacer()
                
                Text(title)
                    .font(.headline)
                
                Spacer()
                
                Button(action: closeAction) {
                    Image(systemName: "xmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: iconSize, height: iconSize)
                }
            }
            .padding()
            
        }
        .frame(height: 44 )
        .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 1)
       
    }
}

#Preview {
    VStack(spacing: 0) {
        CustomOrderToolbar(title: "Order Summary", backAction: {}, closeAction: {}, backgroundColor: .systemGray6)
        Spacer()
    }
}
