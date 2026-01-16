//
//  CategoryCardEntity.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 13/01/26.
//

import SwiftUI

struct CategoryCardEntity: View {
    let category: CategoryEntity // ✅ Takes the Core Data Object
    
    var body: some View {
        VStack {
            // Use AsyncImage with the URL string from DB
            if let urlStr = category.strCategoryThumb, let url = URL(string: urlStr) {
                AsyncImage(url: url) { phase in
                    if let image = phase.image {
                        image.resizable().scaledToFit()
                    } else if phase.error != nil {
                        Color.red.opacity(0.3) // Error placeholder
                    } else {
                        Color.gray.opacity(0.3) // Loading placeholder
                    }
                }
                .frame(height: 100)
                .cornerRadius(8)
            }
            
            Text(category.strCategory ?? "Unknown")
                .font(.subheadline)
                .bold()
                .lineLimit(1)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

//#Preview {
//    
//    let category = Category(idCategory: "1",
//                strCategory: "Chicken",
//                strCategoryThumb:"https://www.themealdb.com/images/category/chicken.png",
//                strCategoryDescription: "Chicken is a type of domesticated fowl, a subspecies of the red junglefowl. It is one of the most common and widespread domestic animals, with a total population of more than 19 billion as of 2011.[1] Humans commonly keep chickens as a source of food (consuming both their meat and eggs) and, more rarely, as pets.")
//
//    CategoryCardEntity(category: category)
//}
