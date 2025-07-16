//
//  MenuItem.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 31/03/25.
//

import Foundation


class MenuItem: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    var children: [MenuItem]?
    var isExpanded: Bool = false
    
    init(title: String, icon: String, children: [MenuItem]? = nil) {
            self.title = title
            self.icon = icon
            self.children = children
    }
}

// Menu items list
class MenuItems {
    static let items = [
        MenuItem(title: "Home", icon: "house.fill"),
        MenuItem(title: "Profile", icon: "person.fill"),
        MenuItem(title: "Settings", icon: "gearshape.fill")
    ]
}

struct MenuDataProvider {
    static func getMenuItems() -> [MenuItem] {
        let homeChildren = [
            MenuItem(title: "Profile", icon: "person.fill"),
            MenuItem(title: "Forgot Password", icon: "lock.rotation")
        ]
        
        let categoryChildren = [
            MenuItem(title: "Veg Food", icon: "leaf.fill"),
            MenuItem(title: "Non Veg Food", icon: "fork.knife")
        ]
        
        let insuranceChildren = [
            MenuItem(title: "Car", icon: "car.fill"),
            MenuItem(title: "Bike", icon: "bicycle"),
            MenuItem(title: "Health", icon: "heart.fill"),
            MenuItem(title: "Setting", icon: "gearshape.fill")
        ]
        
        // Create parent menu items
        let homeItem = MenuItem(title: "Home", icon: "house.fill", children: homeChildren)
        let categoryItem = MenuItem(title: "Category", icon: "square.grid.2x2.fill", children: categoryChildren)
        let insuranceItem = MenuItem(title: "Insurance", icon: "shield.fill", children: insuranceChildren)
        let logoutItem = MenuItem(title: "Logout", icon: "arrow.right.square")
        
        return [homeItem, categoryItem, insuranceItem, logoutItem]
    }
}

