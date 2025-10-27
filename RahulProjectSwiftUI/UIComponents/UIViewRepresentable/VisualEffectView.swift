//
//  VisualEffectView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 24/10/25.
//

import SwiftUI

struct VisualEffectView: UIViewRepresentable {

    var effect: UIVisualEffect?

    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}
