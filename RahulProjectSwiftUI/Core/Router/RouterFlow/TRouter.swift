//
//  TRouter.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 24/04/25.
//

import Foundation

import SwiftUI

// MARK: - Generic Router
//TRouter will manage navPath and stack

final class TRouter<Screen: Hashable & NavigationDestination>: ObservableObject {
    @Published var navPath = NavigationPath()
    @Published var stack: [Screen] = []

    func navigate(to destination: Screen) {
        navPath.append(destination)
        stack.append(destination)
    }

    func navigateBack() {
        guard !navPath.isEmpty else { return }
        navPath.removeLast()
        stack.removeLast()
    }

    func navigateBack(to target: Screen) {
        guard let index = stack.lastIndex(of: target) else { return }
        let removeCount = stack.count - (index + 1)
        navPath.removeLast(removeCount)
        stack.removeLast(removeCount)
    }

    func navigateToRoot() {
        navPath.removeLast(navPath.count)
        stack.removeAll()
    }
}
