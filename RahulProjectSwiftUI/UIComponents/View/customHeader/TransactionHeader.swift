//
//  TransactionHeader.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 07/10/25.
//

import SwiftUI

struct TransactionHeader: View {
    let title: String
    @Binding var searchText: String
    @Binding var selectedFilter: String
    let filters: [String]
    let onMenuTap: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            // Main header row
            HStack {
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                // Multiple action buttons
                HStack(spacing: 16) {
                    Button(action: {
                        print("Filter tapped")
                    }) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .font(.title2)
                    }
                    
                    Button(action: onMenuTap) {
                        Image(systemName: "ellipsis.circle")
                            .font(.title2)
                    }
                }
                .foregroundColor(.primary)
            }
            
            // Search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                
                TextField("Search transactions...", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
            }
            .padding(8)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            
            // Filter chips
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(filters, id: \.self) { filter in
                        FilterChipTransaction(
                            title: filter,
                            isSelected: selectedFilter == filter
                        ) {
                            selectedFilter = filter
                        }
                    }
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial)
    }
}


#Preview {
   
    let filters: [String] = ["Shoes", "Clothing", "Electronics", "Books", "Toys"]
    VStack {
        TransactionHeader(title: "Transaction", searchText: .constant("search here"), selectedFilter: .constant("Shoes"), filters: filters){
            
            print("tapped")
        }
        
    }
}
