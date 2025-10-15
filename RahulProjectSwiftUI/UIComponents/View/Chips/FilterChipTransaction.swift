//
//  FilterChip.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 07/10/25.
//

import SwiftUI
struct FilterChipTransaction: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.blue : Color(.systemGray5))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(15)
        }
    }
}


#Preview {
    
    
    FilterChipTransaction(title: "Data", isSelected: true) {
        
        print("Slected data")
    }
   
//    let filters: [String] = ["Shoes", "Clothing", "Electronics", "Books", "Toys"]
//    VStack {
//        TransactionHeader(title: "Transaction", searchText: .constant("search here"), selectedFilter: .constant("Shoes"), filters: filters){
//            
//            print("tapped")
//        }
//        
//    }
}
