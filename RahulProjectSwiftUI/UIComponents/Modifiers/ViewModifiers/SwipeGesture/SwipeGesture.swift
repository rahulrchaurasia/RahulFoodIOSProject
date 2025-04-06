//
//  SwipeGesture.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 30/12/24.
//

import Foundation
import SwiftUICore
import SwiftUI

struct SwipeGestureModifier: ViewModifier {
    let onSwipe: (SwipeDirection) -> Void

    func body(content: Content) -> some View {
        content
            .gesture(
                DragGesture(minimumDistance: 50)
                    .onEnded { value in
                        let horizontal = value.translation.width
                        let vertical = value.translation.height

                        if abs(horizontal) > abs(vertical) {
                            onSwipe(horizontal < 0 ? .left : .right)
                        } else {
                            onSwipe(vertical < 0 ? .up : .down)
                        }
                    }
            )
    }
}
