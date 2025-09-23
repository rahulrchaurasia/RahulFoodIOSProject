//
//  MealDetailScreen.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 05/09/25.
//

import SwiftUI

//Mark : After CategoryList when we Select particular Item then this details will Open
struct MealDetailScreen: View {
    
  
    @EnvironmentObject var homeVM: HomeViewModel
    let mealId: String

    var body: some View {
        
        Group {
            switch homeVM.mealDetailState {
            case .idle, .loading:
                ProgressView("Loading meal...")
            case .success(let meal):
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        AsyncImage(url: URL(string: meal.strMealThumb)) { image in
                            image.resizable().scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        Text(meal.strMeal).font(.largeTitle).bold()
                        Text(meal.strInstructions)
                    }
                    .padding()
                }
            case .error(let error):
                VStack {
                    Text("❌ Failed to load meal")
                        .foregroundColor(.red)
                    Text(error.localizedDescription)
                    Button("Retry") {
                        Task { await homeVM.getMealDetail(byId: mealId) }
                    }
                }
            }
        }
     
        .task {
                await homeVM.getMealDetail(byId: mealId)
                }
    }
    
}

#Preview {
   
    let mockContainer = MockDependencyContainer()
        let homeVM = mockContainer.makeHomeViewModel()
        

         MealDetailScreen(
           
            mealId: "52772"
        )
}
