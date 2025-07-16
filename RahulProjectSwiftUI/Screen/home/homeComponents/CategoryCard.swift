//
//  CategoryCard.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 08/04/25.
//

import SwiftUI

struct CategoryCard: View {
    let category: Category
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: category.image)) { phase in
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
            
            Text(category.title)
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


#Preview {
    
    let category = Category(id: "1", title: "Data", image: "https://cdn.iconscout.com/icon/free/png-256/pizza-618-1114742.png")
    CategoryCard(category: category)
}
