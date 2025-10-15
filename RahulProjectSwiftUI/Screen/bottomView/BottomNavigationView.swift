//
//  BottomNavigationView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 06/04/25.
//

import SwiftUI

struct BottomNavigationView: View {
    @Binding var selectedTab: TabItem
    @Namespace private var animationNamespace
    
    // For preview purposes
    init(selectedTab: Binding<TabItem> = .constant(.home)) {
        self._selectedTab = selectedTab
    }
    
    // Tab items definition
    enum TabItem: String, CaseIterable {
        case home = "Home"
        case transaction = "Transaction"
        case carJourney = "Car Journey"
        case notification = "Notification"
        
        var icon: String {
            switch self {
            case .home: return "house.fill"
            case .transaction: return "calendar.badge.clock"
            case .carJourney: return "car.fill"
            case .notification: return "bell.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .home: return .red
            case .transaction: return .blue
            case .carJourney: return .indigo
            case .notification: return .purple
            }
        }
    }
    
    var body: some View {
        HStack {
            ForEach(TabItem.allCases, id: \.self) { tab in
                Spacer()
                VStack(spacing: 4) {
                    // Custom animation for selected tab
                    ZStack {
                        if selectedTab == tab {
                            Capsule()
                                .fill(tab.color.opacity(0.2))
                                .frame(width: 60, height: 40)
                                .matchedGeometryEffect(id: "background_circle", in: animationNamespace)
                        }
                        
                        Image(systemName: tab.icon)
                            .font(.system(size: 22))
                            .foregroundColor(selectedTab == tab ? tab.color : .gray)
                    }
                    
                    Text(tab.rawValue)
                        .font(.caption2)
                        .fontWeight(selectedTab == tab ? .semibold : .regular)
                        .foregroundColor(selectedTab == tab ? tab.color : .gray)
                        .fixedSize()
                }
                .frame(height: 70)
                .onTapGesture {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = tab
                    }
                }
                Spacer()
            }
        }
        .padding(.horizontal, 8)
        .padding(.top, 12)
        // Corrected background implementation
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.ultraThinMaterial) // Using the proper material API
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                       

                )
        )
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: -2)
        .padding(.horizontal, 16)
    }
}

#Preview {
    
//    ScrollView() {
//        
//        VStack{
//            Text("hi")
//        }
//        .safeAreaInset(edge: .bottom, spacing: 0) {
//            
//            // Bottom navigation
//            BottomNavigationView(selectedTab: $selectedTab)
//                .padding(.bottom, 8)
//                .offset(x: showMenu && selectedTab == .home ? UIScreen.main.bounds.width * 0.75 : 0)
//                .scaleEffect(showMenu && selectedTab == .home ? 0.9 : 1)
//                .onChange(of: selectedTab) { newValue in
//                    if newValue != .home && showMenu {
//                        withAnimation(.spring()) { showMenu = false }
//                    }
//                }
//        }
//    }
    BottomNavigationView()
}
