//
//  TextStyleModifier.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 07/04/25.
//

import Foundation
import SwiftUICore


import SwiftUI

struct TextStyleModifier: ViewModifier {
    enum TextStyle {
            case header       // Inter SemiBold 24 (maps to .title)
            case title        // Inter SemiBold 20 (maps to .title2)
            case large        // Inter Medium 18 (maps to .title3)
            case medium       // Inter Medium 16 (maps to .callout)
            case mediumRegular // Inter Regular 16 (maps to .body)
            case small        // Inter Medium 14 (maps to .subheadline)
            case smallRegular // Inter Regular 14 (maps to .subheadline)
            case custom(Font)
        }

    let style: TextStyle

    func body(content: Content) -> some View {
        switch style {
                case .header:
                    content.font(.title)
                case .title:
                    content.font(.title2)
                case .large:
                    content.font(.title3)
                case .medium:
                    content.font(.callout)
                case .mediumRegular:
                    content.font(.body)
                case .small:
                    content.font(.subheadline.weight(.medium))
                case .smallRegular:
                    content.font(.subheadline)
                case .custom(let font):
                    content.font(font)
                }
    }
}

extension View {
    func textStyle(_ style: TextStyleModifier.TextStyle) -> some View {
        self.modifier(TextStyleModifier(style: style))
    }
}


/*
 Text("Hello Header")
     .textStyle(.header)

 Text("Medium Regular")
     .textStyle(.mediumRegular)

 Text("Custom Font")
     .textStyle(.custom(.system(size: 20, weight: .bold)))
 */
