//
//  SideMenuView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 31/03/25.
//

import SwiftUI

struct SideMenuView: View {
    @Binding var isShowing: Bool
    @State private var selectedItemIndex: Int? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header
            Text("Profile Details")
                .font(.largeTitle)
                .bold()
                .padding(.top, 60)
                .padding(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
                .padding(.horizontal)
            
            // Menu Items
            ForEach(Array(MenuItems.items.enumerated()), id: \.element.id) { index, item in
                Button(action: {
                    self.selectedItemIndex = index
                    // Add small delay before closing menu for better UX
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation {
                            self.isShowing = false
                        }
                    }
                }) {
                    HStack {
                        Image(systemName: item.icon)
                            .resizable()
                            .frame(width: 20, height: 20)
                        
                        Text(item.title)
                            .font(.headline)
                        
                        Spacer()
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(
                        selectedItemIndex == index ?
                            Color.white.opacity(0.2) :
                            Color.clear
                    )
                    .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width * 0.75)
        .background(Color.blue)
        .edgesIgnoringSafeArea(.vertical)
    }
}

#Preview {
    @State var isShowing = true
      
    SideMenuView(isShowing: $isShowing)

  //  SideMenuView(isShowing: Constant(true))
}

