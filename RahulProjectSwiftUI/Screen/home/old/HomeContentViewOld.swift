//
//  homeContentView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 01/04/25.
//

//Mark: The allowsHitTesting(false) ensures that users can still scroll through this area
import SwiftUI

struct HomeContentViewOld: View {
    @EnvironmentObject var userVM: UserViewModel
   // @EnvironmentObject var router: AppStateRouter
    
    // Use ObservedObject since the view model is created at the parent level
    @ObservedObject var homeVM: HomeViewModel
    
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
                    
                    
                    // Display content based on food data state
                    foodContentView
                    
                    // Add bottom padding that matches navigation height
                    Spacer().frame(height: bottomNavHeight + bottomPadding + CGFloat.bottomInsets)
                }
                .frame(maxWidth: .infinity)
                .padding()
            }
            
            // Loading indicator
            if case .loading = homeVM.state {
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
     private var foodContentView: some View {
         switch homeVM.state {
         case .idle:
             Text("Tap to load food data")
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
                 
         case .success(let dishData):
             // Display food data
             VStack(alignment: .leading, spacing: 24) {
                 // Popular dishes section
                 if !dishData.populars.isEmpty {
                     Text("Popular Dishes")
                         .font(.headline)
                         .padding(.top)
                     
                     ScrollView(.horizontal, showsIndicators: false) {
                         HStack(spacing: 16) {
                             ForEach(dishData.populars) { dish in
                                 DishCard(dish: dish)
                             }
                         }
                     }
                 }
                 
                 
                 // Categories section
                 if !dishData.categories.isEmpty {
                     Text("Categories")
                         .font(.headline)
                         .padding(.top)
                     
                     LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                         ForEach(dishData.categories) { category in
                             CategoryCardFood(category: category)
                         }
                     }
                 }
                 
                 // Special dishes section
                 if !dishData.specials.isEmpty {
                     Text("Special Offers")
                         .font(.headline)
                         .padding(.top)
                     
                     ForEach(dishData.specials) { dish in
                         SpecialDishCard(dish: dish)
                     }
                 }
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


    
// Preview for HomeContentView
    #Preview {
        
        let container = PreviewDependencies.container
           let homeVM = container.makeHomeViewModel()
           
        HomeContentViewOld(homeVM: homeVM)
           // .environmentObject(Router(container: container))
               .environmentObject(UserViewModel())
    }
