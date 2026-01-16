//
//  SlideMenuContentView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 15/04/25.
//

/*
 ***Mark : For Expanding and collapse of menu we used Map function
 
 let's say your menuItems originally has 3 items:


 [
     MenuItem(id: 1, title: "Profile", isExpanded: false),
     MenuItem(id: 2, title: "Settings", isExpanded: false),
     MenuItem(id: 3, title: "Help", isExpanded: false)
 ]
 Now, let’s say the user taps on item with id = 2.

 Then this line:
 
 menuItems = menuItems.map { menuItem in
     var updatedItem = menuItem
     updatedItem.isExpanded = menuItem.id == 2
     return updatedItem
 }
 Will return:

 swift

 [
     MenuItem(id: 1, title: "Profile", isExpanded: false),
     MenuItem(id: 2, title: "Settings", isExpanded: true),
     MenuItem(id: 3, title: "Help", isExpanded: false)
 ]
 So it keeps the same count (3), but only expands the tapped item.

 💡 Summary:
 .map always returns the same number of items as the original list.

 You're just modifying each item based on a condition.

 Great for keeping the list size the same, but changing content inside each item.


 */

/*
 Mark : @Binding var selectedItem: MenuItem?
 selectedItem is a reference to a MenuItem stored outside this view."
 It's a two-way connection — changes to this variable inside SlideMenuContentView also reflect in the parent view (like SideMenuView).
 */

import SwiftUI

struct SlideMenuContentView: View {
    @Binding var isShowing: Bool
    @State var selectedItem: MenuItem? = nil
    @State private var menuItems: [MenuItem] = MenuDataProvider.getMenuItems()
    
   // @EnvironmentObject var router: AppStateRouter
    @EnvironmentObject var userVM: UserViewModel
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject var coordinator: AppCoordinator
    
    // User profile data
    let userName = UserDefaultsManager.shared.loggedInUserName
    let userEmail =  UserDefaultsManager.shared.loggedInUserEmail
    let userMobile =  UserDefaultsManager.shared.loggedInUserMobile
  
    
    init(
        isShowing: Binding<Bool>
       
    ) {
        self._isShowing = isShowing
       
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Profile header
            ProfileHeaderView(
                userName: userName,
                userEmail: userEmail,
                userMobile: userMobile
            )
            
            Divider()
                .background(Color.white.opacity(0.8))
                .padding(.horizontal)
            
            // Menu items with expandable sections
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(menuItems) { item in
                        // Parent menu item
                        ParentMenuItemView(
                            item: item,
                            isSelected: selectedItem?.id == item.id,
                            action: {
                                handleMenuItemTap(item: item)
                            }
                        )
                        
                        // Child items (if expanded)
                        if let children = item.children, item.isExpanded {
                            childItemsSection(for: children, parent: item)
                        }
                    }
                }
                .padding(.vertical, 10)
            }
            
            Spacer()
            // Version info at bottom
            Text("App Version: 1.0.5")
                .font(.caption2)
                .foregroundColor(.white.opacity(0.5))
                .frame(maxWidth: .infinity, alignment: .center)
               
                .padding(.bottom, CGFloat.bottomInsets + 8)
        }
        
    }
    
    
    // Helper method to handle menu item tap
   
    private func handleMenuItemTap(item: MenuItem) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            
            if item.children != nil {
            // Toggle tapped parent, collapse others
                menuItems = menuItems.map{ menuItem in
                    
                    let updatedItem = menuItem
                    
                    if menuItem.id == item.id {
                        
                        updatedItem.isExpanded.toggle()
                    }
                    else{
                        
                        updatedItem.isExpanded = false
                    }
                    return updatedItem
                }
                
                
            } else {
                // For items without children
                handleItemSelection(item)
            }
        }
    }
    
    // Handle selection of menu items
    private func handleItemSelection(_ selectedMenuItem: MenuItem) {
        // Assign a copy of the selected item if needed
        // For simple data structures like this, direct assignment is usually fine
        self.selectedItem = selectedMenuItem
        
        // Add small delay before closing menu for better UX
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation {
                self.isShowing = false
                
                // Handle navigation or action based on the selected item
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    
                    self.navigateToDestination(for: selectedMenuItem)
                }
            }
        }
    }
    
    
    // Helper method to create child items section
    private func childItemsSection(for children: [MenuItem], parent: MenuItem) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(children) { child in
                ChildMenuItemView(child: child) {
                    // Handle child item selection
                    handleItemSelection(child)
                }
            }
        }
        .transition(.opacity.combined(with: .move(edge: .top)))
        .background(Color.white.opacity(0.05))
        .cornerRadius(8)
        .padding(.leading, 20)
        .padding(.trailing, 10)
        .padding(.vertical, 4)
    }
    
    
    //Mark : Menu Slectition base of MenuList
    private func navigateToDestination(for menuItem: MenuItem) {
        // Access router through environment object or passed parameter
        // Assuming you have access to the router
        
        guard let destination = menuItem.destination else {return}
        
        switch destination{
        case .home:
            // Navigate to home
           // router.setRoot(.dashboardModule)
            coordinator.navigate(to: .home(.home))
            
        case .profile:
            // Navigate to profile
            
            coordinator.navigate(to: .home(.profile))
         
        
        case .forgotPassword: break
           // router.navigate(to: .forgotPassword)
            
        case .vegFood, .nonVegFood:
            
            coordinator.navigate(to: .home(.agent))
            
        case .insurance(let type):
            
            //Navigate to Insurance Screen base of Menu
            coordinator.navigate(to: .home(.insurance(type: type)))
            
          case .settings:
            // Navigate to settings
            // router.navigate(to: .settings)
            
            coordinator.navigate(to: .home(.setting))
            
        case .logout :
            // Handle logout
          
           // UserDefaultsManager.shared.logoutUser()
           // router.setRoot( .loginModule)
            
            // Single source of truth: call AppState
            appState.logout()

            
            
            
//        default:
//            // Default case if the title doesn't match any expected value
//            print("No navigation defined for menu item: \(menuItem.title)")
        }
    }
}

#Preview {
    SlideMenuContentView(isShowing: .constant(true))
        .background(Color.appLightGray)
}
