//
//  OrderDetails.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 30/09/25.
//

import Foundation


// Sample data structure for order details
struct OrderDetails {
    let orderId: String = UUID().uuidString.prefix(8).uppercased()
    let productName: String
    let price: Double
    let gst: Double
    var total: Double { price + gst }
    let date: Date = Date()
}
