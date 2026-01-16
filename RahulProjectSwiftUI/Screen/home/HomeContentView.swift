//
//  HomeContentView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 04/09/25.
//

//****************************************
/*
 
 🏆 FINAL ARCHITECTURE (INDUSTRY-GRADE)
 App
  ├── DependencyContainer
  │    └── CoreDataManager (SINGLE)
  │         └── NSPersistentContainer
  │
  ├── .environment(\.managedObjectContext)
  │
  ├── HomeViewModel (StateObject, SINGLE)
  │
  ├── Repository → CoreDataManager.performBackgroundTask
  │
  └── SwiftUI View
       └── @FetchRequest  ✅ auto-updates UI

 ************************************************************
 */
import SwiftUI

struct HomeContentView: View {
    
    @EnvironmentObject var userVM: UserViewModel
    // ✅ Add reference to coordinator
    @EnvironmentObject private var coordinator: AppCoordinator
    
    @EnvironmentObject var homeVM: HomeViewModel // ✅ From environment
    
    @Binding var showMenu: Bool
    
    // Constants for navigation height
    private let bottomNavHeight: CGFloat = 60
    private let bottomPadding: CGFloat = 8
    
    
    // ✅ 1. Connect View to Database (Source of Truth)
    @FetchRequest(
        entity: CategoryEntity.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \CategoryEntity.strCategory, ascending: true)]
    )
    
    var savedCategories: FetchedResults<CategoryEntity>
    
    
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
                   // MealContentView
                    MealContentDBSyncView
                    // Add bottom padding that matches navigation height
                    //                    Spacer().frame(height: bottomNavHeight + bottomPadding + CGFloat.bottomInsets)
                }
                
                .frame(maxWidth: .infinity)
                .padding()
            }
            .safeAreaInset(edge: .top) {
                HomeHeaderWithMenu(title: "Home", showMenuIcon: true) {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        showMenu.toggle()
                    }
                }
            }
            
            // Loading indicator : For without DB
            //            if case .loading = homeVM.CategoryState {
            //                ProgressView()
            //                    .scaleEffect(1.5)
            //                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            //                    .background(Color.black.opacity(0.1))
            //            }
            
            
         //Mark   Goal: Show a full-screen overlay ProgressView when homeVM.isLoading regardless of DB state.
            if (homeVM.isLoading) {
                ProgressView()
                    .scaleEffect(1.5)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.1))
            }
            
            // Bottom mask to hide scrolled content
            // bottomMask
        }
        .refreshable {
            // Use the explicit refresh function when user pulls to refresh
            // await homeVM.refreshFoodDetails()
        }
        
        .task {
            //  await homeVM.getMealCategory()
            await homeVM.syncMealCategories()
        }
        
    }
    
    
    //bottomMask Not using :-->For manually handling bottomView area
    //Instead we used.safeAreaInset(edge: .bottom, spacing: 0) { Bottom nav ..
    
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
    private var MealContentDBSyncView: some View {
        
        // ✅ 2. Check Database Data directly
        if savedCategories.isEmpty {
            
            Text("No Categories Found")
                .foregroundColor(.gray)
                .padding(.top, 50)
            
        }else{
            
            // ✅ 3. Show Data from Core Data
            contentGrid
        }
    }
    
    
    
    // MARK: - Extracted Grid
    private  var contentGrid: some View {
            VStack(alignment: .leading, spacing: 16) {
                Text("Categories").font(.headline)
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    
                    // ✅ Loop through Core Data Entities
                    ForEach(savedCategories, id: \.idCategory) { categoryEntity in
                        
                        // PASS ENTITY, NOT DTO
                        CategoryCardEntity(category: categoryEntity)
                            .onTapGesture {
                                if let name = categoryEntity.strCategory {
                                    coordinator.navigate(to: .home(.mealList(categoryName: name)))
                                }
                            }
                    }
                }
            }
        }
    
    //Mark: when without DB  getMealCategory() are in Used.
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
            errorView(error)
        }
    }
    
    
    private func errorView(_ error: Error) -> some View {
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
                Task {
                    await homeVM.getMealCategory()
                }
            }
            .buttonStyle(.bordered)
            .padding()
        }
        .padding()
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
       
    
    
        
    HomeContentView(  showMenu: .constant(true))
        .environment(\.managedObjectContext,
                            container.coreDataManager.context)
        .environmentObject(UserViewModel())
        .environmentObject(container.makeHomeViewModel())
        .environmentObject(container.makeAppCoordinator())
        .environmentObject(coordinator)
         

}
