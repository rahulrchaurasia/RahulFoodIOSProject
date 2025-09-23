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
        
        Group {
            switch homeVM.mealsState {
            case .idle, .loading:
                ProgressView("Loading meals...")

            case .success(let meals):
                ScrollView {
                    
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(meals) { meal in

                                                 
                            Button {
                                
     
                            } label: {
                                MealCard(meal: meal)
                            }
                            .buttonStyle(PlainButtonStyle()) // ✅ Important for SwiftUI buttons in lists
                        }
                    }
                    .padding() // ✅ Add padding to the whole grid for top/bottom/side margins
                }
                

            case .error(let error):
                VStack(spacing: 12) {
                    Text(error.errorDescription ?? "Failed to load meals")
                        .foregroundColor(.red)
                    Button("Retry") {
                        Task { await homeVM.getMealList(byCategory: category) }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }
        }
        .task(id: category)  { // ✅ runs once per category change
            
            // First, handle the UX by clearing stale data
                homeVM.clearMealList()
            
            print("➡️ selected category is: \(category) ")
            await homeVM.getMealList(byCategory: category)
        }
      
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
