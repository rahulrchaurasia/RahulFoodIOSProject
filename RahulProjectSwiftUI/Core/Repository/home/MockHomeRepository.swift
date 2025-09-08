//
//  MockHomeRepository.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 08/09/25.
//

import Foundation

struct MockHomeRepository : HomeRepositoryProtocol {
   
    
    func getMealCategory() async throws -> CategoryResponse? {
        return CategoryResponse(categories: [
            Category(
                idCategory: "1",
                strCategory: "Seafood",
                strCategoryThumb: "https://www.themealdb.com/images/category/seafood.png",
                strCategoryDescription: "Delicious seafood meals."
            ),
            Category(
                idCategory: "2",
                strCategory: "Dessert",
                strCategoryThumb: "https://www.themealdb.com/images/category/dessert.png",
                strCategoryDescription: "Sweet desserts to enjoy."
            )
        ])
    }
    
    func getMeals(category: String) async throws -> MealResponse {
        return MealResponse(meals: [
            Meal(
                strMeal: "101",
                strMealThumb: "Grilled Salmon",
                idMeal: "https://www.themealdb.com/images/media/meals/1548772327.jpg"
            ),
            Meal(
                strMeal: "102",
                strMealThumb: "Shrimp Pasta",
                idMeal: "https://www.themealdb.com/images/media/meals/1529444830.jpg"
            )
        ])
    }
    
    func getMealDetails(byId id: String) async throws -> MealDetailResponse {
        return MealDetailResponse(meals: [
            MealDetail(idMeal: "1", strMeal: "Mock Meal Detail", strMealThumb: "https://www.themealdb.com/images/media/meals/llcbn01574260722.jpg", strInstructions: "Cook with love ❤️")
                ])
    }
    
    
    func getFoodDetails() async throws -> DishCategoryResponse? {
        
        return nil
    }
    
    func fetchData() async throws -> [String] {
        return ["Apple", "Banana", "Orange", "Mango"]
    }
}
