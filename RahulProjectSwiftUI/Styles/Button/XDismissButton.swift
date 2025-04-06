//
//  XDismissButton.swift
//  SwiftUIDemo
//
//  Created by Rahul Chaurasia on 08/10/23.
//

import SwiftUI

struct XDismissButton: View {
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 40, height: 40)
                .foregroundColor(.white)
                .opacity(0.6)
            
            Image(systemName: "xmark")
                .imageScale(.large)
                .frame(width: 54, height: 54)
                .foregroundColor(.black)
                
        }
    }
}

struct XDismissButton_Previews: PreviewProvider {
    static var previews: some View {
        XDismissButton()
    }
}
