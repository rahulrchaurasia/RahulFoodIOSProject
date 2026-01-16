//
//  MenuItem.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 31/03/25.
//

import Foundation

//For Screen Name OF Menu
enum MenuDestination: Hashable {
    case home
    case profile
    case forgotPassword

    case vegFood
    case nonVegFood

    case insurance(type: InsuranceType)

    case settings
    case logout
}
//💡 Title = UI only
//💡 Destination = logic

class MenuItem: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let destination: MenuDestination?
    var children: [MenuItem]?
    var isExpanded: Bool = false
    
    init(title: String, icon: String, destination: MenuDestination? = nil, children: [MenuItem]? = nil) {
            self.title = title
            self.icon = icon
            self.destination = destination
            self.children = children
    }
}

// Menu items list
//class MenuItems {
//    static let items = [
//        MenuItem(title: "Home", icon: "house.fill"),
//        MenuItem(title: "Profile", icon: "person.fill"),
//        MenuItem(title: "Settings", icon: "gearshape.fill",destination: .settings)
//    ]
//}

struct MenuDataProvider {
    static func getMenuItems() -> [MenuItem] {
        let homeChildren = [
            MenuItem(
                title: "Profile",
                icon: "person.fill",
                destination: .profile
            ),
            MenuItem(
                title: "Forgot Password",
                icon: "lock.rotation",
                destination: .forgotPassword
            )
        ]
        
        let categoryChildren = [
            MenuItem(
                title: "Veg Food",
                icon: "leaf.fill",
                destination: .vegFood
            ),
            MenuItem(
                title: "Non Veg Food",
                icon: "fork.knife",
                destination: .nonVegFood
            )
        ]
        
        let insuranceChildren = [
            MenuItem(title: "Car",
                     icon: "car.fill",
                     destination: .insurance(type: .car),),
            MenuItem(title: "Bike",
                     icon: "bicycle",
                     destination: .insurance(type: .bike)),
            MenuItem(title: "Health",
                     icon: "heart.fill",
                     destination: .insurance(type: .health)),
          
        ]
        
        // Create parent menu items
        let homeItem = MenuItem(title: "Home", icon: "house.fill", children: homeChildren)
        
        let categoryItem = MenuItem(title: "Category", icon: "square.grid.2x2.fill", children: categoryChildren)
        let insuranceItem = MenuItem(title: "Insurance", icon: "shield.fill", children: insuranceChildren)
        
        let settingItem =  MenuItem(title: "Setting", icon: "gearshape.fill",destination: .settings)
        let logoutItem = MenuItem(title: "Logout", icon: "arrow.right.square")
        
        return [homeItem, categoryItem, insuranceItem,settingItem, logoutItem]
    }
}

