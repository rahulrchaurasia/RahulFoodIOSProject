//
//  ReceiptView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 30/09/25.
//


//  ReceiptView.swift

/*
 
 .disabled(true)
 
 .blur(radius: vm.isShowingDetails ? 10 : 0)
 
 
 if vm.isShowingDetails {
     
     //here we pass ObservedObject View Model bec MultiSelectionAlertView decalre it like that
     MultiSelectionAlertView(vm: vm, isShowingDetail: $vm.isShowingDetails)
 }
 */

import SwiftUI

struct ReceiptView: View {
    
    //✅ Add reference to coordinator
    @EnvironmentObject private var coordinator: AppCoordinator
    
    // 1. Create an instance of the ViewModel
        @StateObject private var viewModel = ReceiptViewModel()
        
        let orderDetails: OrderDetails
        var backToHomeAction: () -> Void
    
    
    // State for the PDF share sheet
    @State private var pdfData: Data?
    @State private var showShareSheet = false

    var body: some View {
        
        ZStack {
            VStack(spacing: 0) {
                
            
                CustomToolbar(title: "Receipt",
                 closeAction: {
                    
                    backToHomeAction()
                    
                }, backgroundColor: .systemIndigo)
                
                
                
                ScrollViewReader { proxy in
                    ScrollView {
                        
                        VStack(spacing: 0) {
                            
                            VStack(spacing: 24) {
                                // --- Success Message ---
                                VStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 60)) //Best for SF Symbols
                                        .foregroundColor(.green)
                                        .padding(.bottom, 8)
                                    
                                    Text("Order Placed Successfully!")
                                        .font(.title2)
                                        .bold()
                                    
                                    Text("Thank you for your purchase.")
                                        .font(.headline)
                                        .foregroundColor(.secondary)
                                }
                                .padding(.vertical, 20)
                                
                                // --- Receipt Details Card ---
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("Order ID: \(orderDetails.orderId)")
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                    
                                    Text(orderDetails.productName)
                                        .font(.title3)
                                        .bold()
                                    
                                    Divider()
                                    
                                    ReceiptRow(label: "Price:", value: orderDetails.price)
                                    ReceiptRow(label: "GST:", value: orderDetails.gst)
                                    
                                    Divider()
                                    
                                    ReceiptRow(label: "Total Paid:", value: orderDetails.total, isTotal: true)
                                    
                                    Text("Paid on \(orderDetails.date, formatter: Formatters.itemFormatter)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                    
                                }
                                
                                
                                
                                .padding()
                                .background(Color(.systemBackground))
                                .cornerRadius(12)
                                .shadow(radius: 3)
                                
                                // ✅ 2. ADD AN INVISIBLE ANCHOR AT THE BOTTOM
                            Spacer().id("bottomAnchor")
                                
                            }
                            .padding()
                            
                            
                            // --- Bottom Buttons ---
                            VStack {
                                Button(action: {
                                    
                                    Task{
                                        
                                        await viewModel.generateAndSharePDF(for: orderDetails)
                                    }
                                    
                                })
                                {
                                    Label("Share Receipt as PDF", systemImage: "square.and.arrow.up")
                                        .bold()
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.mint)
                                        .foregroundColor(.white)
                                        .cornerRadius(12)
                                }
                                
                                Button(action: backToHomeAction) {
                                    Text("Back to Home")
                                        .bold()
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .foregroundColor(.mint)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom)
                        }
                        
                    }
                    
                    .task {
                            proxy.scrollTo("bottomAnchor", anchor: .bottom)
                        }
                }
               
                

               
            }
            .background(Color(.systemGray6))
            
            // 3. The sheet now uses the ViewModel's properties
            .sheet(isPresented: $viewModel.showShareSheet) {
                if let pdfURL = viewModel.pdfURL {
                    
                    // Share the file URL, not the Data. This fixes the Gmail issue.
                    ShareSheet(activityItems: [pdfURL])
                }
            }
           
        }
        // 3. Disable the entire UI to prevent taps while the PDF is generating
        .disabled(viewModel.isGeneratingPDF)
    }
    
}

// Helper struct for a row in the receipt
struct ReceiptRow: View {
    let label: String
    let value: Double
    var isTotal: Bool = false
    
    var body: some View {
        HStack {
            Text(label)
                .font(isTotal ? .headline : .body)
            Spacer()
            Text("₹\(value, specifier: "%.2f")")
                .font(isTotal ? .headline : .body)
                .bold(isTotal)
        }
    }
}


#Preview("Full Receipt"){
    
   
    let mockContainer = MockDependencyContainer()
    let homeVM = mockContainer.makeHomeViewModel()
    

    // 2. Create sample data to populate the view
    var sampleOrder: OrderDetails = OrderDetails(
            productName: "Gourmet Cheeseburger",
            price: 550.00,
            gst: 99.00
        )
    
    ReceiptView(
                orderDetails: sampleOrder,
                backToHomeAction: {
                    print("Back to home action tapped!")
                }
            )
            // 3. Inject the mock coordinator into the environment
    .environmentObject(mockContainer.makeHomeViewModel())
    .environmentObject(mockContainer.makeAppCoordinator())

}


#Preview("Row Only"){
    
    
    ReceiptRow(label: "Subtotal", value: 550.00)
}
