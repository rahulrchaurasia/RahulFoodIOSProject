//
//  OrderViewModel.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 01/10/25.
//

import Foundation


class OrderViewModel : ObservableObject {
    
    // MARK: - Published Properties for the View
    
    // All data is pre-formatted as Strings for the UI
    
    @Published var productName: String
    @Published var price : String
    @Published var gst: String
    @Published var total: String
    
    
    // State to control the presentation of the receipt sheet
    @Published var showReceipt = false
    
    // The data model to pass to the ReceiptView
    @Published var orderDetails: OrderDetails
    
    // MARK: - Initialization
    
    init(mealId : String , mealName : String? ){
        
        let priceValue = Double(mealId) ?? 0.0
        let gstValue: Double = 180.0
        let totalValue = priceValue + gstValue
        
        // Prepare the data model
        // ✅ The orderDetails object is created and stored here
        self.orderDetails = OrderDetails(
            productName: mealName ?? "Unknown Meal",
            price: priceValue,
            gst: gstValue
        )
        
        // Prepare the formatted strings for the view
        // ✅ All the strings for the UI are formatted and stored here
        self.productName = mealName ?? "Unknown Meal"
        self.price = String(format: "₹%.2f", priceValue)
        self.gst = String(format: "₹%.2f", gstValue)
        self.total = String(format: "₹%.2f", totalValue)
    }
    
    // MARK: - User Actions
    
    func proceedToPayment() {
        // Here you could add any payment processing logic
        // Once payment is successful, we show the receipt
        showReceipt = true
    }
}
