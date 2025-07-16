//
//  TabContentView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 06/04/25.
//

import SwiftUI

struct TabContentView: View {
    
    @EnvironmentObject var userVM: UserViewModel
    @EnvironmentObject var router: AppStateRouter
    
    @ObservedObject var homeVM: HomeViewModel
    
    let selectedTab: BottomNavigationView.TabItem
    var body: some View {
        Group {
            switch selectedTab {
            case .home:
                HomeContentView( homeVM: homeVM)
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
    
    let apiService = APIService()
    let homeRepository = HomeRepository(apiService: apiService)
   
    let homeVM = HomeViewModel(homeRepository: homeRepository)
    let selectedTab = BottomNavigationView().selectedTab
    TabContentView(homeVM: homeVM, selectedTab: selectedTab)
}
