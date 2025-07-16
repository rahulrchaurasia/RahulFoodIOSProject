//
//  ParentMenuItemView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 15/04/25.
//

import SwiftUI

struct ParentMenuItemView: View {
    let item: MenuItem
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: item.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                
                Text(item.title)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                // Only show chevron if item has children
                if item.children != nil {
                    Image(systemName: item.isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            .background(
                isSelected && item.children == nil ?
                    Color.white.opacity(0.2) :
                    Color.clear
            )
            .cornerRadius(8)
        }
        .foregroundColor(.white)
    }
}

//#Preview {
//    
//    let item = MenuItem(title: "Home", icon: "house",  children: nil)
//        ParentMenuItemView(item: item, isSelected: true) {}
//}

#Preview {
        VStack(spacing: 20) {
            // Regular parent item
            ParentMenuItemView(
                item: MenuItem(title: "Home", icon: "house.fill", children: nil),
                isSelected: false,
                action: {}
            )
            
            // Selected parent item
            ParentMenuItemView(
                item: MenuItem(title: "Settings", icon: "gearshape.fill", children: nil),
                isSelected: true,
                action: {}
            )
            
            // Expanded parent item with children
            ParentMenuItemView(
                item: MenuItem(
                    title: "Category",
                    icon: "square.grid.2x2.fill",
                    children: [
                        MenuItem(title: "Veg Food", icon: "leaf.fill"),
                        MenuItem(title: "Non Veg Food", icon: "fork.knife")
                    ]
                ),
                isSelected: false,
                action: {}
            )
            .background(Color.blue.opacity(0.5))
        }
        .padding()
        .background(Color.blue)
        .previewLayout(.sizeThatFits)
    
}


