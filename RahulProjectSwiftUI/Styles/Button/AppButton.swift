//
//  APButton.swift
//  SwiftUIDemo
//
//  Created by Rahul Chaurasia on 08/10/23.
//

import SwiftUI

struct AppButton: View {
    let title: LocalizedStringKey
    
    var body: some View {
        Text(title)
            .font(.title3)
            .fontWeight(.semibold)
            .frame(width: 260, height: 50)
            .foregroundColor(.white)
            .background(Color.accentColor)
            .cornerRadius(10)
    }
}

struct AppButton_Previews: PreviewProvider {
    static var previews: some View {
        AppButton(title: "Test Title")
    }
}
