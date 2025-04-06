//
//  CustomButton1.swift
//  SwiftUIDemo
//
//  Created by Rahul Chaurasia on 02/02/24.
//

import Foundation
import SwiftUI

struct CustomButton1: View {
    let name: String
    var imgName: String? // Now an optional
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                if let systemImageName = imgName {
                    Image(systemName: systemImageName)
                }
                Text(name)
                    .font(.title3)
            }
            .multilineTextAlignment(.center) // Center text within available space
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .tint(.red)
    }
}

struct CustomButton1_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // With image and text
            CustomButton1(name: "Learn More", imgName: "book.fill") {}
//                

            // With text only
            CustomButton1(name: "Submit", imgName: nil) {
                
            }
//                
        }
    }
}
