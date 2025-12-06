//
//  DOBMask.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 21/11/25.
//

import SwiftUI


struct DOBMask: ViewModifier {
    @Binding var text: String

    func body(content: Content) -> some View {
        content
            .keyboardType(.numberPad)
            .onChange(of: text) { newValue in
                let numbers = newValue.filter(\.isNumber)

                var result = ""
                for (i, d) in numbers.enumerated() {
                    if i == 2 || i == 4 { result.append("-") }
                    result.append(d)
                    if result.count == 10 { break }
                }

                if result != newValue {
                    text = result
                }
            }
    }
}

extension View {
    func dobMask(_ text: Binding<String>) -> some View {
        modifier(DOBMask(text: text))
    }
}
