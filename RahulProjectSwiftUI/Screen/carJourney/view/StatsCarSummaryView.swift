//
//  StatsCarSummaryView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 13/10/25.
//

import SwiftUI

/*
 viewModel.paymentStatusSummary[status]
 
 It’s actually dictionary lookup using the subscript operator.
 Dictionary    Access by key (any Hashable)    myDict["Paid"]    Value for that key or nil
 
 means dict[key] give value
 
 so “Give me the count (Int) for this status (String) key from the dictionary.”
 */
struct StatsCarSummaryView: View {
    
    @ObservedObject var viewModel : CarViewModel
    
    @Binding var selectedPaymentStatus : String?
    var body: some View {
       
        
        ScrollView(.horizontal,showsIndicators: false) {
            
            HStack(spacing:12) {
                
            ForEach(viewModel.availablePaymentStatuses, id: \.self)
                { status in
                    
                    if let count = viewModel.paymentStatusSummary[status]{
                        
                        StatusChip(status: status, count: count, isSelected: selectedPaymentStatus == status) {
                            
                            if selectedPaymentStatus == status {
                                
                                selectedPaymentStatus = nil
                                viewModel.filterByPaymentStatus(nil)
                                
                            }
                            else{
                                selectedPaymentStatus = status
                                viewModel.filterByPaymentStatus(status)
                            }
                                
                        }
                        
                    }
                    
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
    }
}

#Preview {
    
    let container = PreviewDependencies.container
    let viewModel = container.makeCarViewModel()

    
    
    StatsCarSummaryView(viewModel: viewModel, selectedPaymentStatus: .constant("Approved"))
            .task {
                // Trigger fetch in preview
                await viewModel.fetchAllData()
            }
}
