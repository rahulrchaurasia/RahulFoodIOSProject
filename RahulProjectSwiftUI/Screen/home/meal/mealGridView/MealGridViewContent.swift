//
//  MealGridViewContent.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 24/09/25.
//

import SwiftUI

struct MealGridViewContent: View {
    
    @EnvironmentObject var homeVM: HomeViewModel   // just grab it
    @EnvironmentObject private var coordinator: AppCoordinator
    let category: String
  
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    // ✅ Add reference to coordinator
      

    var body: some View {
        Group {
            switch homeVM.mealsState {
            case .idle, .loading:
                ProgressView("Loading meals...")

            case .success(let mealSummary):
                ScrollView {
                    
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(mealSummary) { meal in
                            
                            
                            Button {
                                
                                coordinator.navigate(to: .home(.mealDetail(mealId: meal.idMeal)))
                            } label: {
                                MealCard(mealSummary: meal)
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
//    let homeVM = MockDependencyContainer().makeHomeViewModel()
//    MealGridViewContent(homeVM: homeVM, category: "22", coordinator: <#T##AppCoordinator#>)
//}
