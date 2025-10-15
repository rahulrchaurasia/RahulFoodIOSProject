//
//  searchAndFilterView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 13/10/25.
//

import SwiftUI

struct SearchAndFilterView: View {
    
    @ObservedObject var viewModel : CarViewModel
    
    @Binding var searchText : String
    @Binding var showFilters : Bool
    @Binding var selectedPaymentStatus : String?
    var onClearAll:   (()-> Void)?
    
    var body: some View {
        
        VStack(spacing : 12){
            // Search Bar - JUST ADD FILTER BUTTON HERE
            
            HStack{
                
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                
                TextField("Search by name, passport, certificate...", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                
                    .onChange(of: searchText) { newValue in
                        
                        viewModel.search(with: newValue)
                    }
                
                // Clear search button
                
                if !searchText.isEmpty {
                    
                    Button {
                        
                        searchText = ""
                        viewModel.clearSearch()
                    } label: {
                        Image(systemName:  "xmark.circle.fill" )
                            .foregroundStyle(.secondary)
                    }
                    
                    
                }
                
                // ✅ ADD FILTER BUTTON HERE - Perfect location!
                
                Button {
                
                    showFilters = true // This opens the filter sheet
                } label: {
                    
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .font(.title3)
                        .foregroundStyle(.blue)
                }

                
            }
           
            .padding(10)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)
            
             //Active Filters
                    if viewModel.searchCriteria.isActive {
                        ActiveFiltersView(viewModel: viewModel, searchText: $searchText, selectedPaymentStatus: $selectedPaymentStatus, onClearAll: onClearAll )
                    }
        }
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
            
    }
}

#Preview {
   // searchAndFilterView()
    
    let container = PreviewDependencies.container
    let viewModel = container.makeCarViewModel()

    
    SearchAndFilterView(viewModel: viewModel, searchText:.constant("pending"), showFilters: .constant(true), selectedPaymentStatus: .constant("pending"))
    
   
}
