//
//  OrderScreen.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 26/09/25.
//

/*
 The ViewModel is simple and doesn’t depend on external DI/repository logic.

 You just need a quick local instance — like a detail or subview (e.g. MealDetailViewModel).

 There’s no strong need for dependency injection or testing in isolation.

 ⚠️ But:

 It couples your View and ViewModel tightly.

 Harder to test or reuse, because View always creates its own ViewModel.

 In complex apps with many dependencies (repositories, coordinators, etc.), this can break DI consistency.
 
 ********************************
 For DI Point OF View :
 
    @StateObject private var viewModel: OrderViewModel

     init(viewModel: OrderViewModel) {
         _viewModel = StateObject(wrappedValue: viewModel)
     }
 */

import SwiftUI

struct OrderScreen: View {
    
    
    let mealId : String
    let mealName : String?
    
    @EnvironmentObject var coordinator: AppCoordinator
    
    // 1. The view now holds a StateObject for the ViewModel
    @StateObject private var viewModel : OrderViewModel
    
    // 2. The initializer creates the ViewModel, passing the necessary data
    init(mealId: String, mealName: String?) {
        
        // --- THE FIX IS HERE ---
        self.mealId = mealId
        self.mealName = mealName
        _viewModel = StateObject(wrappedValue: OrderViewModel(mealId: mealId, mealName: mealName))
        
    }
   
      
       
    
    var body: some View {
            ZStack {
                // Background color
                Color(.systemGray6)
                    .ignoresSafeArea(.all)
                
                VStack(spacing: 0) {
                    
                    CustomToolbar(
                        
                    title: "Order Summary",
                    backAction: {
                       // coordinator.navigateBack()
                                                
                        coordinator.popToPreviousCase(.home(.mealList(categoryName: "")))
                        
                    },
                    
                    rightAction: ToolbarAction(
                            icon: "xmark",
                            action: {
                                
                                coordinator.popToPreviousCase(.home(.mealList(categoryName: "")))
                            }
                        )
                    
                    )
                    
                    // Title + back button (default NavigationBar)
                    Text("") // Empty placeholder; we use .navigationTitle
                        .frame(height: 0)
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            // 3. All data is now read directly from the ViewModel
                            Text(viewModel.productName)
                                .font(.title2)
                                .bold()
                            
                            HStack {
                                Text("Price:")
                                Spacer()
                                Text(viewModel.price)
                            }
                            
                            HStack {
                                Text("GST:")
                                Spacer()
                                Text(viewModel.gst)
                            }
                            
                            Divider()
                            
                            HStack {
                                Text("Total:")
                                    .font(.headline)
                                Spacer()
                                Text(viewModel.total)
                                    .font(.headline)
                            }
                            
                            Spacer(minLength: 100) // leave space for button
                        }
                        .padding()
                    }
                    
                    // Payment button pinned to bottom using safe area
                   
                    Button(action: {
                      
                        viewModel.proceedToPayment()
                    }) {
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
        
            .sheet(isPresented: $viewModel.showReceipt) {
                
                // Present the ReceiptView
                ReceiptView(orderDetails: viewModel.orderDetails) {
                    // This is the "Back to Home" action.
                    // It will be executed when the button in ReceiptView is tapped.
                    viewModel.showReceipt = false // Dismiss the sheet
                    coordinator.popToRoot()  // Then, navigate home
                }
                
                .presentationDetents([.fraction(0.75), .fraction(0.9)]) // allows medium & large detents
                .presentationDragIndicator(.visible) // show drag handle
                
                .interactiveDismissDisabled(false)  // allow swipe down
            }
        }
    
    
}

#Preview {
    
   
    OrderScreen(mealId: "200", mealName: "Choclate")
        .environmentObject(MockDependencyContainer().makeAppCoordinator())
}
