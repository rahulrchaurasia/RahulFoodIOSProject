//
//  HomeRepositoryProtocol.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 08/04/25.
//

import Foundation

protocol HomeRepositoryProtocol {
    
    func getFoodDetails() async throws -> DishCategoryResponse?
}
