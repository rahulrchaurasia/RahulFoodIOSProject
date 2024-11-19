//
//  customTextViewModifier.swift
//  SwiftUIDemo
//
//  Created by Rahul Chaurasia on 13/07/23.
//

import SwiftUI

struct CustomTextViewModifier: ViewModifier {
      var roundedCornes: CGFloat
      var textColor: Color

      func body(content: Content) -> some View {
          content
              .padding()
        
              .cornerRadius(roundedCornes)
              .padding(2)
              .foregroundColor(textColor)
              .overlay(
                RoundedRectangle(cornerRadius: roundedCornes)
                .stroke( lineWidth: 1) 
                .foregroundColor(Color.gray.opacity(0.7)))
              .font(.custom("Open Sans", size: 17))

              .shadow(radius: 10)
      }
}


