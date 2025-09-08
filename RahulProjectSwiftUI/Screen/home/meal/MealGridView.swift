//
//  MealGridView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 05/09/25.
//

import SwiftUI

struct MealGridView: View {
    @ObservedObject var homeVM: HomeViewModel
    let category: String
    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        switch homeVM.mealsState {
        case .idle, .loading:
            ProgressView("Loading meals...")

        case .success(let meals):
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(meals) { meal in
                        NavigationLink {
                            MealDetailScreen(homeVM: homeVM, mealId: meal.idMeal)
                        } label: {
                            MealCard(meal: meal)
                        }
                    }
                }
                .padding()
            }
            .task(id: category) { // ✅ runs once per category change
                await homeVM.getMeals(byCategory: category)
            }

        case .error(let error):
            VStack(spacing: 12) {
                Text(error.errorDescription ?? "Failed to load meals")
                    .foregroundColor(.red)
                Button("Retry") {
                    Task { await homeVM.getMeals(byCategory: category) }
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}

#Preview {
    
    let mockContainer = MockDependencyContainer()
    let homeVM = mockContainer.makeHomeViewModel()
    
    MealGridView(
           homeVM: homeVM,
           category: "Seafood"
       )

//    MealGridView(
//            homeVM: HomeViewModel(homeRepository: MockHomeRepository()), // inject mock repo
//            category: "Seafood"
//        )
}
