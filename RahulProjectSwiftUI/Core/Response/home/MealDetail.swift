//
//  MealDetail.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 04/09/25.
//

import Foundation


struct MealDetailResponse: Codable {
    let meals: [Meal]
}

// MARK: - Ingredient
struct Ingredient: Identifiable {
    let id = UUID()
    let name: String
    let measure: String
}


// MARK: - Meal
struct Meal: Codable, Identifiable {
    
    // Conform to Identifiable
    var id: String { idMeal }
    
    let idMeal: String
    let strMeal: String
    let category: String?
    let area: String?
    let instructions: String?
    let thumbnail: String? 
    let youtubeURL: String?
    let sourceURL: String?
    
    // Ingredients
    private let strIngredient1: String?
    private let strIngredient2: String?
    private let strIngredient3: String?
    private let strIngredient4: String?
    private let strIngredient5: String?
    private let strIngredient6: String?
    private let strIngredient7: String?
    private let strIngredient8: String?
    private let strIngredient9: String?
    private let strIngredient10: String?
    private let strIngredient11: String?
    private let strIngredient12: String?
    private let strIngredient13: String?
    private let strIngredient14: String?
    private let strIngredient15: String?
    private let strIngredient16: String?
    private let strIngredient17: String?
    private let strIngredient18: String?
    private let strIngredient19: String?
    private let strIngredient20: String?
    
    private let strMeasure1: String?
    private let strMeasure2: String?
    private let strMeasure3: String?
    private let strMeasure4: String?
    private let strMeasure5: String?
    private let strMeasure6: String?
    private let strMeasure7: String?
    private let strMeasure8: String?
    private let strMeasure9: String?
    private let strMeasure10: String?
    private let strMeasure11: String?
    private let strMeasure12: String?
    private let strMeasure13: String?
    private let strMeasure14: String?
    private let strMeasure15: String?
    private let strMeasure16: String?
    private let strMeasure17: String?
    private let strMeasure18: String?
    private let strMeasure19: String?
    private let strMeasure20: String?
    
    // MARK: - Coding Keys
    enum CodingKeys: String, CodingKey {
        case idMeal = "idMeal"
        case strMeal = "strMeal"
        case category = "strCategory"
        case area = "strArea"
        case instructions = "strInstructions"
        case thumbnail = "strMealThumb"
        case youtubeURL = "strYoutube"
        case sourceURL = "strSource"
        
        case strIngredient1, strIngredient2, strIngredient3, strIngredient4, strIngredient5,
             strIngredient6, strIngredient7, strIngredient8, strIngredient9, strIngredient10,
             strIngredient11, strIngredient12, strIngredient13, strIngredient14, strIngredient15,
             strIngredient16, strIngredient17, strIngredient18, strIngredient19, strIngredient20
        
        case strMeasure1, strMeasure2, strMeasure3, strMeasure4, strMeasure5,
             strMeasure6, strMeasure7, strMeasure8, strMeasure9, strMeasure10,
             strMeasure11, strMeasure12, strMeasure13, strMeasure14, strMeasure15,
             strMeasure16, strMeasure17, strMeasure18, strMeasure19, strMeasure20
    }
    
    // MARK: - Computed Ingredients Array
    var ingredients: [Ingredient] {
        let names = [
            strIngredient1, strIngredient2, strIngredient3, strIngredient4, strIngredient5,
            strIngredient6, strIngredient7, strIngredient8, strIngredient9, strIngredient10,
            strIngredient11, strIngredient12, strIngredient13, strIngredient14, strIngredient15,
            strIngredient16, strIngredient17, strIngredient18, strIngredient19, strIngredient20
        ]
        
        let measures = [
            strMeasure1, strMeasure2, strMeasure3, strMeasure4, strMeasure5,
            strMeasure6, strMeasure7, strMeasure8, strMeasure9, strMeasure10,
            strMeasure11, strMeasure12, strMeasure13, strMeasure14, strMeasure15,
            strMeasure16, strMeasure17, strMeasure18, strMeasure19, strMeasure20
        ]
        
        return zip(names, measures)
            .compactMap { (name, measure) in
                if let name = name, !name.trimmingCharacters(in: .whitespaces).isEmpty {
                    return Ingredient(name: name, measure: measure ?? "")
                }
                return nil
            }
    }
}

extension Meal {
    init(
        id: String,
        name: String,
        category: String? = nil,
        area: String? = nil,
        instructions: String? = nil,
        thumbnail: String? = nil,
        youtubeURL: String? = nil,
        sourceURL: String? = nil
    ) {
        self.idMeal = id
        self.strMeal = name
        self.category = category
        self.area = area
        self.instructions = instructions
        self.thumbnail = thumbnail
        self.youtubeURL = youtubeURL
        self.sourceURL = sourceURL
        
        // Ingredients default to nil
        self.strIngredient1 = nil
        self.strIngredient2 = nil
        self.strIngredient3 = nil
        self.strIngredient4 = nil
        self.strIngredient5 = nil
        self.strIngredient6 = nil
        self.strIngredient7 = nil
        self.strIngredient8 = nil
        self.strIngredient9 = nil
        self.strIngredient10 = nil
        self.strIngredient11 = nil
        self.strIngredient12 = nil
        self.strIngredient13 = nil
        self.strIngredient14 = nil
        self.strIngredient15 = nil
        self.strIngredient16 = nil
        self.strIngredient17 = nil
        self.strIngredient18 = nil
        self.strIngredient19 = nil
        self.strIngredient20 = nil

        self.strMeasure1 = nil
        self.strMeasure2 = nil
        self.strMeasure3 = nil
        self.strMeasure4 = nil
        self.strMeasure5 = nil
        self.strMeasure6 = nil
        self.strMeasure7 = nil
        self.strMeasure8 = nil
        self.strMeasure9 = nil
        self.strMeasure10 = nil
        self.strMeasure11 = nil
        self.strMeasure12 = nil
        self.strMeasure13 = nil
        self.strMeasure14 = nil
        self.strMeasure15 = nil
        self.strMeasure16 = nil
        self.strMeasure17 = nil
        self.strMeasure18 = nil
        self.strMeasure19 = nil
        self.strMeasure20 = nil
    }
}
