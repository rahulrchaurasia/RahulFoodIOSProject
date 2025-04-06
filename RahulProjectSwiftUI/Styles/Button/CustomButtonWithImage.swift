//
//  CustomButtonWithImage.swift
//  SwiftUIDemo
//
//  Created by Rahul Chaurasia on 02/02/24.
//

import Foundation
import SwiftUI

struct CustomButtonWithImage: View {
    let name: String
    let imageName: String
    let action: () -> Void

    @State private var sheetMode: SheetMode = .none

    var body: some View {
        Button {
            
            action() // Perform the button's action
        } label: {
            Label(name, systemImage: imageName)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .tint(.red)
    }
}

struct CustomButtonWithImage_Previews: PreviewProvider {
    static var previews: some View {
        CustomButtonWithImage(name: "Submit",imageName: "book.fill", action: {
            print("action triggered")
        })
    }
}

