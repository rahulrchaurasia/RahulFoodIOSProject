//
//  HomeContentView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 04/09/25.
//

import SwiftUI

struct HomeContentView: View {
    
    @EnvironmentObject var userVM: UserViewModel
    
    // ✅ Add reference to coordinator
       @EnvironmentObject private var coordinator: AppCoordinator

    // Use ObservedObject since the view model is created at the parent level
   // @ObservedObject var homeVM: HomeViewModel
    
    @EnvironmentObject var homeVM: HomeViewModel // ✅ From environment
   
 
    // Constants for navigation height
    private let bottomNavHeight: CGFloat = 60
    private let bottomPadding: CGFloat = 8
    
    
    var body: some View {
        // Main container with background color extending to edges
        ZStack(alignment: .top) {
            // Background that extends all the way
            Color.bg
                .ignoresSafeArea()
            
            // Scrollable content with clipping at bottom
            ScrollView (showsIndicators: false){
                VStack(spacing: 16) {
                    
                    
                    // Display content based on Meal data state
                    MealContentView
                    
                    // Add bottom padding that matches navigation height
                    Spacer().frame(height: bottomNavHeight + bottomPadding + CGFloat.bottomInsets)
                }
              
                .frame(maxWidth: .infinity)
                .padding()
            }
            
            // Loading indicator
            if case .loading = homeVM.CategoryState {
                ProgressView()
                    .scaleEffect(1.5)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.1))
            }
            
            // Bottom mask to hide scrolled content
            bottomMask
        }
        .refreshable {
            // Use the explicit refresh function when user pulls to refresh
           // await homeVM.refreshFoodDetails()
        }
        
        .task {
            await homeVM.getMealCategory()
        }
//
//        .alert(homeVM.alertState.title, isPresented: $homeVM.showError, actions: {
//            Button("OK", role: .none, action: {})
//        }, message: {
//            Text(userVM.errorMessage)
//        })
    }
    
    
    private var bottomMask : some View {
        VStack {
            Spacer()
            Rectangle()
                .fill(Color.bg)
                .frame(height: bottomNavHeight + bottomPadding + CGFloat.bottomInsets)
                .allowsHitTesting(false) // Let touches pass through
        }
        .ignoresSafeArea()
    }
    
    
    
    // MARK: - Food Content View
     @ViewBuilder
     private var MealContentView: some View {
         switch homeVM.CategoryState {
         case .idle:
             Text("Tap to load Meal data")
                 .font(.body)
                 .foregroundColor(.secondary)
                 .onAppear {
//                     Task {
//                         await homeVM.getFoodDetails()
//                     }
                 }
                 
         case .loading:
             // Loading is handled by the overlay
             EmptyView()
                 
         case .success(let categories):
             // Display food data
             VStack(alignment: .leading, spacing: 24) {
                 // Popular dishes section
                 
               //Mark : First give Category List
                 
                 // Categories section
                 if !categories.isEmpty {
                     Text("Categories")
                         .font(.headline)
                         .padding(.top)
                     
                     LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                         ForEach(categories) { category in
                             CategoryCard(category: category){
                              
                                 //Mark : Naviaget to particuular category List
                                 // ✅ Handle category tap here
                                print("Category tapped: \(category.strCategory)")
                                                                
                            // Navigate to meal list for this category
//                                 coordinator.navigate(to: .home(.mealDetail(mealId: category.idCategory)))
                                 
                     coordinator.navigate(to: .home(.mealList(categoryName: category.strCategory)))
                                                                
                             }
                         }
                     }
                 }
                 
//                 // Special dishes section
//                 if !dishData.specials.isEmpty {
//                     Text("Special Offers")
//                         .font(.headline)
//                         .padding(.top)
//                     
//                     ForEach(dishData.specials) { dish in
//                         SpecialDishCard(dish: dish)
//                     }
//                 }
             }
                 

         case .error(let error):
             VStack {
                 Image(systemName: "exclamationmark.triangle")
                     .font(.largeTitle)
                     .foregroundColor(.red)
                     .padding()
                 
                 Text("Could not load food data")
                     .font(.headline)
                 
                 Text(error.localizedDescription)
                     .font(.subheadline)
                     .foregroundColor(.secondary)
                     .multilineTextAlignment(.center)
                     .padding()
                 
                 Button("Try Again") {
//                     Task {
//                         await homeVM.getFoodDetails()
//                     }
                 }
                 .buttonStyle(.bordered)
                 .padding()
             }
             .padding()
         }
     }
    
    
    
 
}




#Preview {
  
    
    let container = PreviewDependencies.container
    
    // This will call the OVERRIDDEN method and return a MockAppCoordinator
    // This will now correctly return a MockAppCoordinator.
    let coordinator = container.makeAppCoordinator()
    
    // The container now provides all necessary mock dependencies
       let homeVM = container.makeHomeViewModel()
    
    let userVM = UserViewModel() // Or create via container if you set
       
    
    
        
    HomeContentView()
        .environmentObject(UserViewModel())
        .environmentObject(container.makeHomeViewModel())
        .environmentObject(coordinator)
         

}
