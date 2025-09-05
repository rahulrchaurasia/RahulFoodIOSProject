//
//  HomeRepositoryProtocol.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 08/04/25.
//

import Foundation

protocol HomeRepositoryProtocol {
    
    func getMealCategory() async throws -> CategoryResponse?
    
    func getMeals(category: String) async throws -> MealResponse
    
    func getMealDetails(byId id: String) async throws -> MealDetailResponse
    
    func getFoodDetails() async throws -> DishCategoryResponse?
}
