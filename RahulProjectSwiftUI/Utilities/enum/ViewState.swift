//
//  LoadingState.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 01/04/25.
//

import Foundation


// MARK: - View State
enum ViewState<T> {
    case idle
    case loading
    case success(T)
    case error(NetworkError)
}

extension ViewState: Equatable where T: Equatable {
    static func == (lhs: ViewState<T>, rhs: ViewState<T>) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case (.loading, .loading):
            return true
        case (.success(let lhsValue), .success(let rhsValue)):
            return lhsValue == rhsValue
        case (.error(let lhsError), .error(let rhsError)):
            return lhsError == rhsError
        default:
            return false
        }
    }
}
