//
//  ReceiptPDFView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 30/09/25.
//

import SwiftUI

//  ReceiptPDFView.swift

import SwiftUI

// This view is designed to be rendered into a PDF.
// It's separate from the main view to allow for specific PDF formatting.
struct ReceiptPDFView: View {
    let orderDetails: OrderDetails
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header
            Text("Tax Invoice")
                .font(.largeTitle.bold())
                .foregroundColor(.mint)
            
            Text("Rahul's Food App")
                .font(.title2)
            
            Divider()

            // Order Info
            VStack(alignment: .leading, spacing: 8) {
                Text("**Order ID:** \(orderDetails.orderId)")
                Text("**Date:** \(orderDetails.date.formatted(date: .long, time: .shortened))")
            }
            
            Divider()
            
            // Item Details
            VStack(alignment: .leading) {
                Text("ITEMS")
                    .font(.headline)
                    .foregroundColor(.secondary)
                HStack {
                    Text(orderDetails.productName)
                        .font(.title3.bold())
                    Spacer()
                    Text("₹\(orderDetails.price, specifier: "%.2f")")
                        .font(.title3)
                }
            }
            
            Divider()
            
            // Totals
            VStack(spacing: 8) {
                ReceiptRow(label: "Subtotal:", value: orderDetails.price)
                ReceiptRow(label: "GST:", value: orderDetails.gst)
                ReceiptRow(label: "Total Paid:", value: orderDetails.total, isTotal: true)
            }
            
            Spacer()
            
            // Footer
            Text("Thank you for your order!")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(40) // Add significant padding for PDF margins
        .frame(width: 595, height: 842) // A4 paper size in points
        .background(.white)
    }
}

#Preview {
    let orderDetail = OrderDetails(productName: "Chocklate", price: 200, gst: 10)
    ReceiptPDFView(orderDetails: orderDetail)
}
