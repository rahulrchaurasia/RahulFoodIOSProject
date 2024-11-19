//
//  CommonNavigationBarModifier.swift
//  SwiftUIDemo
//
//  Created by Rahul Chaurasia on 30/09/23.
//

import Foundation
import SwiftUI


struct CommonNavigationBarModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
    .navigationTitle("")
      .navigationBarTitle("")
      .navigationBarBackButtonHidden(true)
      .navigationBarHidden(true)
      
      
      
     
  }
}
