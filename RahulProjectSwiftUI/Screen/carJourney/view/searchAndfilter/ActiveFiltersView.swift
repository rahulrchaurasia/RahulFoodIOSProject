//
//  ActiveFiltersView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 14/10/25.
//

import SwiftUI

/*
 Why Set to nil?
 When a filter chip is showing, it means a filter is currently active. Tapping it should remove that filter (toggle off).
 
 
 . Show Active Filter (Simple):
 swift
 // Show chip only if filter is active
 if let status = selectedPaymentStatus {
     FilterChip(title: "Status: \(status)") {
         // Remove filter when tapped
         selectedPaymentStatus = nil
         viewModel.filterByPaymentStatus(nil)
     }
 }
 3. Clear All (Simple):
 swift
 private func clearAllFilters() {
     searchText = ""
     selectedPaymentStatus = nil
     viewModel.clearSearch()
 }
 
 */

// MARK: - Active Filters View dynamically
/* Note :
 * isActive automatically becomes true whenever any filter or search query is applied.

 * activeFiltersView only shows when isActive == true.

 * Each chip has a tap action that clears that filter individually.

 * “Clear All” clears everything, resetting searchCriteria and the UI.

 * This pattern scales well:

 * Add more filters like date, agent, or multiple payment statuses.

 * Just update isActive in ProposalSearchCriteria to reflect any active filter.

 * The UI automatically shows chips for all active filters and the “Clear All” button.
 */

struct ActiveFiltersView: View {
    
    @ObservedObject var viewModel : CarViewModel
    @Binding var searchText : String
    @Binding var selectedPaymentStatus : String?
    var onClearAll:   (()-> Void)?
    
    
    var body: some View {
      
        ScrollView(.horizontal, showsIndicators: false){
            
            
            HStack(spacing : 8){
                
                if !searchText.isEmpty{
                    FilterChip(title: "Search \(searchText)", systemImage: "magnifyingglass") {
                        
                        searchText = ""
                        viewModel.search(with: "")
                    }
                }
                
                
                if let status = selectedPaymentStatus{
                    
                    FilterChip(title: "Status:\(status)", systemImage: "checkmark.circle") {
                        
                        selectedPaymentStatus = nil   // ✅ Clear UI state
                        viewModel.filterByPaymentStatus(nil) // ✅ Clear filter logic
                    }
                }
                
                
                Button("Clear All") {
                    onClearAll?()
                }
                .font(.caption)
                .foregroundColor(.blue)
            }
            .padding(.horizontal)
        }
        
    }
}

#Preview {
    
    let container = PreviewDependencies.container
    let viewModel = container.makeCarViewModel()
//    FilterSheetView(selectedPaymentStatus: .constant("pending"), showFilters: .constant(false), viewModel: viewModel)
    ActiveFiltersView(viewModel: viewModel, searchText: .constant(""), selectedPaymentStatus: .constant("pending"))
}
