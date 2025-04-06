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
    
    init(title: String, icon: String) {
        self.title = title
        self.icon = icon
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

