//
//  MealResponse.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 04/09/25.
//

import Foundation

// MARK: - MealResponse
struct MealResponse: Codable {
    let meals: [Meal]
}

// MARK: - Meal
struct Meal: Codable,Identifiable {
    let strMeal: String
    let strMealThumb: String
    let idMeal: String
    
    var id: String { idMeal }
}
