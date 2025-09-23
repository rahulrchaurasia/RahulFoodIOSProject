//
//  CategoryCard.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 04/09/25.
//

import SwiftUI

struct CategoryCard: View {
    let category: Category
    var onTap : (()-> Void)? = nil // ✅ Add tap handler
    
    var body: some View {
        
        Button {
            onTap?() // ✅ Call the tap handler
        } label: {
            
            VStack {
                AsyncImage(url: URL(string: category.strCategoryThumb)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    case .failure:
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: 60, height: 60)
                
                Text(category.strCategory)
                    .font(.caption)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)

        }

    }
}



#Preview {
    
    
    
    let category = Category(idCategory: "1",
                strCategory: "Chicken",
                strCategoryThumb:"https://www.themealdb.com/images/category/chicken.png",
                strCategoryDescription: "Chicken is a type of domesticated fowl, a subspecies of the red junglefowl. It is one of the most common and widespread domestic animals, with a total population of more than 19 billion as of 2011.[1] Humans commonly keep chickens as a source of food (consuming both their meat and eggs) and, more rarely, as pets.")
    CategoryCard(category: category)
}

