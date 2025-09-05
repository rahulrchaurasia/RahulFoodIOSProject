//
//  SpecialDishCard.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 09/04/25.
//

//Mark :  .foregroundStyle(.appgray)
//Imp : .clipShape(RoundedRectangle(cornerRadius: 10)) modifier to the second implementation, which will ensure the image stays within its bounds and doesn't overlap with the adjacent VStack content.
import SwiftUI

struct SpecialDishCard: View {
    
    let dish: DishItem
    
    var body: some View {
            
        HStack{
            AsyncImage(url: URL(string: dish.image)){  phase  in
                
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure(let error):
                    
                    Image(systemName: "photo.fill")
                        .resizable()
                        .frame(width: 60,height: 60)
                        .foregroundStyle(Color.gray)
                    
                    
                @unknown default:
                    
                    EmptyView()
                }
            }
            
            .frame(width: 80, height: 80)
            .foregroundStyle(Color.red.opacity(0.6))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading, spacing: 4){
                
                Text(dish.name)
                    .font(.headline)
                
                Text("\(dish.calories) cal")
                    .font(.caption)
                    .foregroundStyle(Color.gray)
                
                Text(dish.description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            .padding(.leading,8)
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
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
    return SpecialDishCard(dish: sampleDish)
            .previewLayout(.sizeThatFits)
            .padding()
}
