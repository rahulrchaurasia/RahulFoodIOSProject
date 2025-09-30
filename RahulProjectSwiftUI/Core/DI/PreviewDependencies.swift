//
//  PreviewDependencies.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 19/04/25.
//

import Foundation

struct PreviewDependencies {
    static var container: MockDependencyContainer {
//        let container = DependencyContainer(apiService: APIService())
//        // Configure any mock services if needed
//        return container
        
        return MockDependencyContainer()
    }
}
