//
//  SideMenuView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 31/03/25.
//

import SwiftUI

struct SideMenuView: View {
    @Binding var isShowing: Bool
 
    var body: some View {

        
        SlideMenuContentView(isShowing: $isShowing)
        .frame(width: UIScreen.main.bounds.width * 0.75)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.blueMenu, Color.blue]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .edgesIgnoringSafeArea(.vertical)
    }
}

#Preview {
     
    SideMenuView(isShowing: .constant(true))


}

