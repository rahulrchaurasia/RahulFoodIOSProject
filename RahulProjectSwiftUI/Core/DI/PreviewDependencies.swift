//
//  PreviewDependencies.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 19/04/25.
//

import Foundation

struct PreviewDependencies {
    static var container: DependencyContainer {
        let container = DependencyContainer(apiService: APIService())
        // Configure any mock services if needed
        return container
    }
}
