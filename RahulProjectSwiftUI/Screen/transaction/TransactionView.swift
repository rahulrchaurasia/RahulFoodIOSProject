//
//  TransactionView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 07/10/25.
//

import SwiftUI

struct TransactionView: View {
    
    @State private var selectedFilter = "All"
        @State private var searchText = ""
    
    let filters = ["All", "Completed", "Pending", "Failed"]
    var body: some View {
        
        
        ZStack (alignment: .top) {
            
            Color.bg.ignoresSafeArea()
            
            ScrollView(showsIndicators: false){
                
                VStack(spacing: 16) {
                    
                    ForEach(0..<10,id: \.self ){ index in
                        
                        TransactionRow(index: index)
                    }
                    // Bottom padding
                    Spacer().frame(height: 68 + CGFloat.bottomInsets)
                }
                
            }
            .safeAreaInset(edge: .top) {
                TransactionHeader(
                    title: "Transactions",
                    searchText: $searchText,
                    selectedFilter: $selectedFilter,
                    filters: filters,
                    onMenuTap: {
                        print("Transaction menu tapped")
                        // Handle additional menu actions
                    }
                )
            }
        }
    }
}

#Preview {
    TransactionView()
}
