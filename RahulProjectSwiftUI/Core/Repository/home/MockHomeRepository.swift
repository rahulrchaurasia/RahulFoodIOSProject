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
            MealSummary(
                strMeal: "101",
                strMealThumb: "Grilled Salmon",
                idMeal: "https://www.themealdb.com/images/media/meals/1548772327.jpg"
            ),
            MealSummary(
                strMeal: "102",
                strMealThumb: "Shrimp Pasta",
                idMeal: "https://www.themealdb.com/images/media/meals/1529444830.jpg"
            )
        ])
    }
    
    func getMealDetails(byId id: String) async throws -> MealDetailResponse {
        
        
        let sampleMeal: Meal = Meal(
            id: "53050",
            name: "Ayam Percik",
            thumbnail: "https://www.themealdb.com/images/media/meals/020z181619788503.jpg",
            youtubeURL: "https://www.youtube.com/watch?v=9ytR28QK6I8",
            sourceURL: "http://www.curiousnut.com/roasted-spiced-chicken-ayam-percik/"
        )

            
        return MealDetailResponse(meals: [sampleMeal])

    }
    
    
    func getFoodDetails() async throws -> DishCategoryResponse? {
        
        return nil
    }
    
    func fetchData() async throws -> [String] {
        return ["Apple", "Banana", "Orange", "Mango"]
    }
}
