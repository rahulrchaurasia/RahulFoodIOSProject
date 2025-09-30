//
//  MealResponse.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 04/09/25.
//

import Foundation

// MARK: - MealResponse
struct MealResponse: Codable {
    let meals: [MealSummary]
}

// MARK: - Meal
struct MealSummary: Codable,Identifiable {
    let strMeal: String
    let strMealThumb: String
    let idMeal: String
    
    var id: String { idMeal }
}
