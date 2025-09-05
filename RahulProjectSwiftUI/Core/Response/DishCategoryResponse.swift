//
//  DishCategoryResponse.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 08/04/25.
//

import Foundation


// Example model for dish categories
struct DishCategoryResponse: Decodable {
    let status: Int
    let message: String
    let data: DishData
}

struct DishData: Decodable {
    let categories: [Category1]
    let populars: [DishItem]
    let specials: [DishItem]
}

struct Category1: Decodable, Identifiable {
    let id: String
    let title: String
    let image: String
}

struct DishItem: Decodable, Identifiable {
    let id: String
    let name: String
    let description: String
    let image: String
    let calories: Int
}
