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
    
    /*
   Mark :  The line guard !state.isLoading else { return } acts as a protective gate that prevents duplicate network requests when data is already being loaded. Here's a detailed breakdown:


     */
    var isLoading: Bool {
          if case .loading = self { return true }
          return false
      }
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

extension ViewState {
    var isSuccess: Bool {
        if case .success = self { return true }
        return false
    }
}
