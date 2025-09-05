//
//  Categories.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 01/09/25.
//

import Foundation


// MARK: - Categories DishCategoryResponse
struct CategoryResponse: Decodable {
    let categories: [Category]
}

// MARK: - Category
struct Category: Decodable,Identifiable {
    let idCategory, strCategory: String
    let strCategoryThumb: String
    let strCategoryDescription: String?
    
    // This satisfies Identifiable
    var id: String { idCategory }
}
