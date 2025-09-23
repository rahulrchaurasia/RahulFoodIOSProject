//
//  MealCard.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 08/09/25.
//

import SwiftUI

struct MealCard: View {
    
    let meal : Meal
    
    var body: some View {
        
        VStack {
            AsyncImage(url: URL(string: meal.strMealThumb)) { image in
                image.resizable()
                // This makes the image a square that fills its container
                    .aspectRatio(1, contentMode: .fill)
            } placeholder: {
                // Give the placeholder a frame so the card doesn't resize while loading
                Color.gray.opacity(0.1)
                    .aspectRatio(1, contentMode: .fit)
            }
            // Let's clip the image to the top corners of the card
            .clipped()
            // TEXT
            VStack {
                Text(meal.strMeal)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                // Ensure text takes up full width for centering
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(8) // Add some padding around the text
            .frame(height: 70) // Give the text area a consistent height
            
        }
        // This is the main card styling
        .background(.background) // Use the adaptive background color
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.15), radius: 4, y: 2)
        
        
    }
    
}

#Preview {
    
    let meal = Meal(strMeal: "Fish fofos", strMealThumb: "https://www.themealdb.com/images/media/meals/a15wsa1614349126.jpg", idMeal: "1")
    MealCard(meal: meal)
}
