//
//  CustomTextWithIconViewModifier.swift
//  SwiftUIDemo
//
//  Created by Rahul Chaurasia on 09/02/24.
//

import Foundation
import SwiftUI

struct CustomTextWithIconViewModifier: ViewModifier {
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
          .stroke(lineWidth: 1.5)
          .foregroundColor(Color.gray.opacity(0.7))
      )
      .font(.custom("Open Sans", size: 17))
      .shadow(radius: 10)
  }
}

//struct CustomTextWithIconViewModifier_Previews: PreviewProvider {
//        static var previews: some View {
//
////            let vm: OTPAlertViewModel = OTPAlertViewModel()
////             PasswordAlertView(vm: vm)
//            CustomTextWithIconViewModifier(roundedCornes: 20, textColor: .black)
//           
//        }
//}
