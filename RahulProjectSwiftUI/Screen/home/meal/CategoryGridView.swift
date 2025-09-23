//
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 05/09/25.
//

import SwiftUI

struct CategoryGridView: View {
    //@ObservedObject var homeVM: HomeViewModel
    @EnvironmentObject var homeVM: HomeViewModel
    let category: String
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    // ✅ Add reference to coordinator
       @EnvironmentObject private var coordinator: AppCoordinator

    var body: some View {
        switch homeVM.mealsState {
        case .idle, .loading:
            ProgressView("Loading meals...")

        case .success(let meals):
            ScrollView {
                
                

                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(meals) { meal in

                                             
                        Button {
                            
                            print("Button Clicked for \(meal.strMeal)")
//                            coordinator.navigate(to: .home(.mealDetail(mealId: meal.idMeal)))
//     
                            
                        } label: {
                            MealCard(meal: meal)
                        }
                        .buttonStyle(PlainButtonStyle()) // ✅ Important for SwiftUI buttons in lists
                    }
                }
                .padding()
            }
            .task(id: category) { // ✅ runs once per category change
//                await homeVM.getMealDetail(byId: <#T##String#>)(byCategory: category)
            }

        case .error(let error):
            VStack(spacing: 12) {
                Text(error.errorDescription ?? "Failed to load meals")
                    .foregroundColor(.red)
                Button("Retry") {
//                    Task { await homeVM.getMeals(byCategory: category) }
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}

//#Preview {
//    
//    let mockContainer = MockDependencyContainer()
//    let homeVM = mockContainer.makeHomeViewModel()
//    
//    CategoryGridView(
//           homeVM: homeVM,
//           category: "Seafood"
//       )
//
//
//}
