//
//  ViewStateOverlay.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 12/09/25.
//

import SwiftUICore
import SwiftUI


struct ViewStateOverlay<T: Equatable>: View { // The generic <T> is the key
    let state: ViewState<T>
    
    var body: some View {
        switch state {
        case .idle:
            EmptyView()
        case .loading:
            ProgressView("Loading...")
                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                .scaleEffect(2)
        case .success:
            EmptyView() // navigation handled externally
        case .error:
            EmptyView() // could show inline error here, or rely on alert
        }
    }
}
