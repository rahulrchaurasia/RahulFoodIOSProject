//
//  CustomOrderToolbar.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 29/09/25.
//

import SwiftUICore
import SwiftUI


struct ToolbarAction {
    let icon: String
    let action: () -> Void
}


struct CustomToolbar: View {
    var title: String
    var backAction: (() -> Void)? = nil
    var rightAction: ToolbarAction? = nil // ✅ generic
    var backgroundColor: Color?
    var tintColor: Color = .primary   // ✅ new
    private let iconSize: CGFloat = 20
    
    var body: some View {
            ZStack {
                (backgroundColor ?? Color.clear)
                    .background(.ultraThinMaterial)
                    .ignoresSafeArea(edges: .top)
                
                HStack {
                    // LEFT (Back)
                    if let backAction = backAction {
                        Button(action: backAction) {
                            Image(systemName: "arrow.backward")
                                .resizable()
                                .scaledToFit()
                                .frame(width: iconSize, height: iconSize)
                                .foregroundColor(tintColor)
                        }
                        .buttonStyle(.plain)
                    } else {
                        Spacer().frame(width: iconSize)
                    }
                    
                    Spacer()
                    
                    Text(title)
                        .font(.headline)
                    
                    Spacer()
                    
                    // RIGHT (Custom)
                    if let rightAction = rightAction {
                        Button(action: rightAction.action) {
                            Image(systemName: rightAction.icon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: iconSize, height: iconSize)
                                .foregroundColor(tintColor)
                        }
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
      
        
        CustomToolbar(
            title: "Car Insurance",
            backAction: {  },
            rightAction: ToolbarAction(
                icon: "plus",
                action: {  }
            ),
            backgroundColor: .systemGray6
        )
        
        Spacer()
    }
}
