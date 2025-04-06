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
            VStack {
                // Display different content based on selected tab
                switch selectedTab {
                case .home:
                    HomeContentView()
                case .transaction:
                    TransactionContentView()
                case .carJourney:
                    CarJourneyContentView()
                case .notification:
                    NotificationContentView()
                }
            }
        }
}

#Preview {
    
    let selectedTab = BottomNavigationView().selectedTab
    TabContentView(selectedTab: selectedTab)
}
