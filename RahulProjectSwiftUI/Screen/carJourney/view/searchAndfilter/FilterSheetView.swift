//
//  filterSheetView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 10/10/25.
//

import SwiftUI

struct FilterSheetView: View {
    
    @Binding var selectedPaymentStatus : String?
    
    @Binding var showFilters : Bool
   
    @ObservedObject var viewModel: CarViewModel
    var body: some View {
        List{
            
            Section("Payment Status") {
                
                ForEach(viewModel.availablePaymentStatuses, id: \.self ){ status in
                 
                    HStack{
                        Text(status)
                        
                        Spacer()
                        
                        if(selectedPaymentStatus == status){
                            
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        
                        selectedPaymentStatus = status
                        
                        viewModel.filterByPaymentStatus(status)
                        
                        showFilters = false
                    }
                    
                }
            }
        }
    }
}

#Preview {
    let container = PreviewDependencies.container
    let viewModel = container.makeCarViewModel()
    FilterSheetView(selectedPaymentStatus: .constant("pending"), showFilters: .constant(false), viewModel: viewModel)
}
