//
//  MealGridView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 17/09/25.
//

import SwiftUI

struct MealGridView: View {
   // @ObservedObject var homeVM: HomeViewModel
    @EnvironmentObject var homeVM: HomeViewModel   // just grab it
    let category: String
  
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    // ✅ Add reference to coordinator
       @EnvironmentObject private var coordinator: AppCoordinator

    var body: some View {
        
       // Text("Hi Done")
        
        VStack(spacing : 0) {
            
            CustomNavigationBar(title: category) {
                coordinator.navigateBack()
            }
           
            Spacer()
            
            MealGridViewContent(category: category)
                .ignoresSafeArea(edges: .top)
            Spacer()
           
        }
        .navigationBarHidden(true)
       
      
    }
}

//#Preview {
//    
//    let mockContainer = MockDependencyContainer()
//    let homeVM = mockContainer.makeHomeViewModel()
//    
//    
//    MealGridView(homeVM: homeVM, category: "Chicken")
//}
