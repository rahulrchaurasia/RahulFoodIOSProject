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
    //✅ Add reference to coordinator
    @EnvironmentObject private var coordinator: AppCoordinator
    
    let mealId: String
       
    @State private var isSharePresented = false
    
    var body: some View {
        
      //  Text("Detail Screen")
        
        
        Group{
            switch homeVM.mealDetailState {
            case .idle, .loading:
                ProgressView("Loading meal...")
                    .font(.headline)
                    .padding()
                
            case .success(let meal):
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        
                        // MARK: Hero Image
                        AsyncImage(url: URL(string: meal.thumbnail ?? "")) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .shadow(radius: 6)
                        } placeholder: {
                            ProgressView()
                                .frame(maxWidth: .infinity, minHeight: 200)
                        }
                        
                        // MARK: Meal Name
                        Text(meal.strMeal)
                            .font(.largeTitle)
                            .bold()
                            .padding(.top)
                        
                        Divider()
                        
                        // MARK: Category + Area
                        HStack {
                            if let category = meal.category {
                                Label(category, systemImage: "fork.knife")
                            }
                            if let area = meal.area{
                                Label(area, systemImage: "globe.asia.australia")
                            }
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        
                        Divider()
                        
                        CustomButton(title: "Ordered") {
                            
                            coordinator.navigate(to: .home(.order(mealId: "334" ,mealName : "Silk Chocklate")))
                        }
                        
                        // MARK: Instructions
                        Text("Instructions")
                            .font(.title2)
                            .bold()
                            .padding(.bottom, 4)
                        
                        Text(meal.instructions ?? "***")
                            .font(.body)
                            .multilineTextAlignment(.leading)
                        
                        // MARK: Ingredients
                        if let ingredients = meal.ingredientsList, !ingredients.isEmpty {
                            Divider()
                            
                            Text("Ingredients")
                                .font(.title2)
                                .bold()
                                .padding(.bottom, 4)
                            
                            ForEach(ingredients, id: \.self) { item in
                                Text("• \(item)")
                                    .font(.body)
                            }
                        }
                        
                        Spacer(minLength: 40)
                    }
                    .padding()
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { isSharePresented = true }) {
                            Label("Share", systemImage: "square.and.arrow.up")
                        }
                    }
                    ToolbarItem(id: "back", placement: .navigationBarLeading) {
                       
                        Button(action: {
                            coordinator.navigateBack()
                        }) {
                            Image(systemName: "arrow.left")
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Color.black.opacity(0.4))
                                .clipShape(Circle())
                        }
                    }
                }
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarBackground(Color.mint, for: .navigationBar)
                .sheet(isPresented: $isSharePresented) {
                    if let url = URL(string: meal.sourceURL ?? "https://www.themealdb.com/meal/\(meal.idMeal)") {
                        ActivityView(activityItems: [meal.strMeal, url])
                    } else {
                        ActivityView(activityItems: [meal.strMeal])
                    }
                }
                
            case .error(let error):
                VStack(spacing: 12) {
                    Text("❌ Failed to load meal")
                        .foregroundColor(.red)
                    Text(error.localizedDescription)
                        .font(.caption)
                    Button("Retry") {
                        Task { await homeVM.getMealDetail(byId: mealId) }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }
        }
        
        .task {
            await homeVM.getMealDetail(byId: mealId)
        }
        .navigationTitle("Meal Details")
        .navigationBarTitleDisplayMode(.inline)
    }
    
}

extension Meal {
    var ingredientsList: [String]? {
        var list: [String] = []
        let mirror = Mirror(reflecting: self)
        for child in mirror.children {
            if let label = child.label,
               label.starts(with: "strIngredient"),
               let ingredient = child.value as? String,
               !ingredient.trimmingCharacters(in: .whitespaces).isEmpty {
                list.append(ingredient)
            }
        }
        return list.isEmpty ? nil : list
    }
}

#Preview {
    
    let mockContainer = MockDependencyContainer()
    let homeVM = mockContainer.makeHomeViewModel()
    
    let coordinator = AppCoordinator()
    MealDetailScreen(
        
        mealId: "52772"
    )
    .environmentObject(homeVM)
    .environmentObject(coordinator)     // ✅ Inject AppCoordinator

}
