//
//  DividerView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 18/11/24.
//

import SwiftUI

struct DividerView: View {
    
    var bgColor : Color = Color.gray
    var dividerHeight : CGFloat = 1
    var body: some View {
            VStack {
                Divider()
                    .frame(height: dividerHeight)
                    .background(bgColor) // Optional customization
            }
        }
}

#Preview {
    DividerView()
}
