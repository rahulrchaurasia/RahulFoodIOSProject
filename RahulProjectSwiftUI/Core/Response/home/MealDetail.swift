//
//  MealDetail.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 04/09/25.
//

import Foundation



// MARK: - MealDetailResponse
struct MealDetailResponse: Decodable {
    let meals: [MealDetail]
}


// MARK: - MealDetail
struct MealDetail: Decodable, Identifiable {
    let idMeal: String
    let strMeal: String
    let strMealThumb: String
    let strInstructions: String

    var id: String { idMeal }
}

