//
//  OrderScreen.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 26/09/25.
//

import SwiftUI

struct OrderScreen: View {
    
    
    let mealId : String
    let mealName : String?
    
    @EnvironmentObject var coordinator: AppCoordinator
   
    // Sample product info
    
    var productName: String {
        mealName ?? ""
    }
   
    var price: Double {
        Double(mealId) ?? 0.0
    }
   
    let gst: Double = 180
    
    var total: Double { price + gst }
    
    var body: some View {
            ZStack {
                // Background color
                Color(.systemGray6)
                    .ignoresSafeArea(.all)
                
                VStack(spacing: 0) {
                    
                    CustomOrderToolbar(
                        
                    title: "Order Summary",
                    backAction: {
                       // coordinator.navigateBack()
                                                
                        coordinator.popToPreviousCase(.home(.mealList(categoryName: "")))
                        
                    },
                    closeAction: {
                        
                        coordinator.popToPreviousCase(.home(.mealList(categoryName: "")))
                    })
                    
                    // Title + back button (default NavigationBar)
                    Text("") // Empty placeholder; we use .navigationTitle
                        .frame(height: 0)
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            // Product Details
                            Text(productName)
                                .font(.title2)
                                .bold()
                            
                            HStack {
                                Text("Price:")
                                Spacer()
                                Text("₹\(price, specifier: "%.2f")")
                            }
                            
                            HStack {
                                Text("GST:")
                                Spacer()
                                Text("₹\(gst, specifier: "%.2f")")
                            }
                            
                            Divider()
                            
                            HStack {
                                Text("Total:")
                                    .font(.headline)
                                Spacer()
                                Text("₹\(total, specifier: "%.2f")")
                                    .font(.headline)
                            }
                            
                            Spacer(minLength: 100) // leave space for button
                        }
                        .padding()
                    }
                    
                    // Payment button pinned to bottom using safe area
                   
                    Button(action: { print("Proceed to payment") }) {
                        Text("Pay Now")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.mint)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .padding(.horizontal)
                            .padding(.bottom, 10) // safe area bottom already included
                    }
                }
            }
            .navigationBarHidden(true) // hide system navigation bar
            .navigationBarBackButtonHidden(false) // default back button
        }
    
    
}

#Preview {
    
   
    OrderScreen(mealId: "200", mealName: "Choclate")
}
