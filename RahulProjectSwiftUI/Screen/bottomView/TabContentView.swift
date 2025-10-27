//
//  TabContentView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 06/04/25.
//

import SwiftUI

struct TabContentView: View {
    @ObservedObject var carVM: CarViewModel
    let selectedTab: BottomNavigationView.TabItem
    
    // We need the binding to pass it down to the home tab
    @Binding var showMenu: Bool

    var body: some View {
        // The switch now determines the entire view for each tab, including its header
        switch selectedTab {
        case .home:
            // The Home tab gets its content view WITH the header included.
            HomeContentView(showMenu: $showMenu)
            
        case .transaction:
            // Placeholder for Transaction view
            //Text("Transaction View"
           // TransactionContentView()
            TransactionView()
        case .carJourney:
            // ✅ CarJourneyContentView has no extra header. It's just itself.
          //  CarJourneyContentView(carVM: carVM)
            CarJourneyScreen(viewModel: carVM)
            
        case .notification:
            // Placeholder for Notification view
            //Text("Notification View")
            
           // NotificationMain()
            NotificationLatestView()
        }
    }
}

#Preview {
    
    let apiService = APIService()
    let container = PreviewDependencies.container
    
    let homeRepository = HomeRepository(apiService: apiService)
    let coordinator = container.makeAppCoordinator()
   
    let homeVM = HomeViewModel(homeRepository: homeRepository)
    let selectedTab = BottomNavigationView().selectedTab
    TabContentView( carVM: container.makeCarViewModel(), selectedTab: selectedTab, showMenu: .constant(true))
        .environmentObject(homeVM)
       
}
