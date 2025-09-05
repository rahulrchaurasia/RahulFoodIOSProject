//
//  DishCard.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 08/04/25.
//

import SwiftUI

struct DishCard: View {
    let dish: DishItem
    
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: dish.image)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure:
                    Image(systemName: "photo")
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 120, height: 120)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Text(dish.name)
                .font(.subheadline)
                .lineLimit(1)
            
            Text("\(dish.calories) cal")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(width: 120)
    }
}

#Preview {
    
    let sampleDish = DishItem(
            id: "item1",
            name: "Pizza Napoletana",
            description: "Traditional Neapolitan pizza with fresh ingredients",
            image: "https://res.cloudinary.com/dn4pokov0/image/upload/v1611311563/d3f69e36ea17c0e0bb129ba1403e24dc.png",
            calories: 320
        )
    return DishCard(dish: sampleDish)
            .previewLayout(.sizeThatFits)
            .padding()
}
