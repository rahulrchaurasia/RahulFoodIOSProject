//
//  TabContentView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 06/04/25.
//

import SwiftUI

struct TabContentView: View {
    
    @EnvironmentObject var userVM: UserViewModel
    @EnvironmentObject var router: Router
    
    let selectedTab: BottomNavigationView.TabItem
    var body: some View {
        Group {
            switch selectedTab {
            case .home:
                HomeContentView()
            case .transaction:
                Text("Transaction Screen")
            case .carJourney:
                Text("Car Journey Screen")
            case .notification:
                Text("Notification Screen")
            }
        }
        }
}

#Preview {
    
    let selectedTab = BottomNavigationView().selectedTab
    TabContentView(selectedTab: selectedTab)
}
