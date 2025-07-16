//
//  ChildMenuItemView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 15/04/25.
//

import SwiftUI

struct ChildMenuItemView: View {
    let child: MenuItem
    let action: () -> Void
    @State private var isHovered = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                // Subtle indicator line instead of rectangle
                Rectangle()
                    .frame(width: 2, height: 20)
                    .foregroundColor(.white.opacity(0.3))
                
                Image(systemName: child.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .foregroundColor(.white.opacity(0.9))
                
                Text(child.title)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))
                
                Spacer()
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 8)
            .background(isHovered ? Color.white.opacity(0.1) : Color.clear)
            .cornerRadius(6)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .onHover { hovering in
            isHovered = hovering
        }
    }
}

//#Preview {
//    
//   let item = MenuItem(title: "Profile", icon: "person.circle")
//    ChildMenuItemView(child: item){}
//}

struct ChildMenuItemView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 8) {
            // Regular child item
            ChildMenuItemView(
                child: MenuItem(title: "Profile", icon: "person.fill"),
                action: {}
            )
            
            // Child item with a different icon
            ChildMenuItemView(
                child: MenuItem(title: "Forgot Password", icon: "lock.rotation"),
                action: {}
            )
            
            // Child item with a longer title
            ChildMenuItemView(
                child: MenuItem(title: "Account Settings and Preferences", icon: "gearshape.fill"),
                action: {}
            )
        }
        .padding()
        .background(Color.blue)
        .previewLayout(.sizeThatFits)
    }
}
