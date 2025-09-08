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
                image.resizable().scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 150, height: 150)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            Text(meal.strMeal)
                .font(.headline)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .padding(.top, 4)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.systemBackground)
        .cornerRadius(12)
        .shadow(radius: 2)
        
        
    }
    
}

#Preview {
    
    let meal = Meal(strMeal: "Fish fofos", strMealThumb: "https://www.themealdb.com/images/media/meals/a15wsa1614349126.jpg", idMeal: "1")
    MealCard(meal: meal)
}
