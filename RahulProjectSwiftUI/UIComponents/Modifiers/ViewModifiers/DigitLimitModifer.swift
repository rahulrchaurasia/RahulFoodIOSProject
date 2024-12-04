//
//  DigitLimitModifer.swift
//  SwiftUIDemo
//
//  Created by Rahul Chaurasia on 10/06/24.
//

import Foundation
import SwiftUI

struct DigitLimitModifer: ViewModifier {
  @Binding var value: String
  var length: Int

  func body(content: Content) -> some View {
    content
      .onChange(of: value) { newValue in
          value = String(String(newValue.filter { $0.isNumber })
            .prefix(length)) // Truncate if exceeding limit
      }
  }
}

extension View {
  func limitDigitInput(value: Binding<String>, length: Int) -> some View {
    modifier(DigitLimitModifer(value: value, length: length))
  }
}
