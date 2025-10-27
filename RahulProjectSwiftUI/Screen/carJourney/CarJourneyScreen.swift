//
//  CarJourneyScreen.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 03/10/25.
//

import SwiftUI

import Combine
import Kingfisher


// CarJourneyScreen

//  CarJourneyScreen.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 03/10/25.
//

import SwiftUI

import Combine
import Kingfisher

/*
 
 Note : we handle only pinned view Using
    LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
 
  Apply this to top safe area, shadows, and buttons for proper fade effects.

 can write a fully corrected CarJourneyScreen and CollapsingBannerView where:
 1. collapseProgress works correctly.
 2. Top safe area overlay fades properly.
 3. Filter button and shadows animate smoothly.

 */
// CarJourneyScreen

//  CarJourneyScreen.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 03/10/25.
//


//  Not working : collapseProgress and Prefrence key both
import SwiftUI

import Combine
import Kingfisher

/*
 
 
 Summary
 * The current scrollOffset is not properly representing collapse progress because of the banner offset adjustments.
 * Use a GeometryReader inside CollapsingBannerView to get the actual banner height.
 * Compute collapseProgress as:


 collapseProgress =  1   −     bannerHeight−minHeight
                               __________________________.
                               maxHeight − minHeight

 Apply this to top safe area, shadows, and buttons for proper fade effects.

 can write a fully corrected CarJourneyScreen and CollapsingBannerView where:
 1. collapseProgress works correctly.
 2. Top safe area overlay fades properly.
 3. Filter button and shadows animate smoothly.

 */
struct CarJourneyScreen: View {
    @ObservedObject var viewModel: CarViewModel
    @State private var showFilters = false
    @State private var selectedPaymentStatus: String? = nil
    @State private var searchText = ""
    
   
    // MARK: - Scroll & Banner Tracking
        @State private var scrollOffset: CGFloat = 0
        @State private var bannerHeight: CGFloat = 0 // ✅ COMMITED: actual banner height for collapseProgress

    
    private let maxHeaderHeight: CGFloat = UIScreen.main.bounds.height * 0.27
    private let minHeaderHeight: CGFloat = 0
    
    
    // Collapsing progress (0 → expanded, 1 → collapsed)
    private var collapseProgress: CGFloat {
        let range = maxHeaderHeight - minHeaderHeight
        guard range > 0 else { return 0 }
        let progress = 1 - ((bannerHeight - minHeaderHeight) / range)
        return min(max(progress, 0), 1)
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            // Background
            Color(UIColor.systemGray6)
                .ignoresSafeArea()
            
            // MARK: - Scrollable Content
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                    
                    // ✅ FIXED: Use the same scroll tracking as working example
                    // Scroll tracking
                    GeometryReader { geo in
                        Color.clear
                            .preference(key: ScrollOffsetPreferenceKey.self,
                                        value: -geo.frame(in: .named("scroll")).origin.y)
                    }
                    .frame(height: 0)
                    
                    
                    // MARK: - Collapsing Banner Section
                    bannerSection
                    
                    
                    // ✅ Pinned Header Section
                    Section(header: pinnedHeader) {
                        proposalSection
                            .background(Color(UIColor.systemGray6))
                    }
                }
            }
            .coordinateSpace(name: "scroll")
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { scrollOffset = $0 }
         
            .onPreferenceChange(BannerHeightPreferenceKey.self) { newHeight in
                bannerHeight = newHeight
                
                // ✅ DEBUG PRINT
                let range = maxHeaderHeight - minHeaderHeight
                let progress = 1 - ((newHeight - minHeaderHeight) / range)
                print("🧭 collapseProgress: \(progress), bannerHeight: \(newHeight)")
            }
            
            // MARK: - Top Safe Area Overlay
                        Color(UIColor.systemGray6)
                            .frame(height: safeAreaTopInset)
                            .opacity(collapseProgress) // ✅ COMMITED Added
                            .ignoresSafeArea(edges: .top)
                            .allowsHitTesting(false)
                            .animation(.easeInOut(duration: 0.25), value: collapseProgress)

            
            // ✅ Loading Overlay
            if viewModel.isLoading {
                
            LoaderView(isLoading: viewModel.isLoading, message: "Fetching your car journeys…")
                
            }
        }
       // .ignoresSafeArea(edges: .top)
        .task {
            viewModel.fetchAllData()
        }
        .onDisappear {
            viewModel.cancelAll()
        }
        .sheet(isPresented: $showFilters) {
            FilterSheetView(selectedPaymentStatus: $selectedPaymentStatus,
                            showFilters: $showFilters,
                            viewModel: viewModel)
        }
        .animation(.easeInOut(duration: 0.25), value: collapseProgress)
    }
    
    
    // MARK: - Helpers
    private var safeAreaTopInset: CGFloat {
        UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.windows.first?.safeAreaInsets.top }
            .first ?? 0
    }
    
}

private extension CarJourneyScreen {
    
    private func clearAllFilters() {
        searchText = ""
        selectedPaymentStatus = nil
        viewModel.clearSearch()
    }
    
    var bannerSection: some View {
        
        Group{
            
            switch viewModel.bannerState {
            case .idle, .loading:
                EmptyView()
            
            case .success(let banners):
                

                
                if banners.isEmpty {
                                    EmptyBannerPlaceholder()
                                        .frame(height: maxHeaderHeight)
                                        .ignoresSafeArea(edges: .top)
                                } else {
                                    CollapsingBannerView(
                                        banners: banners,
                                        scrollOffset: scrollOffset,
                                        maxHeight: maxHeaderHeight,
                                        minHeight: minHeaderHeight
                                    )
                                    .ignoresSafeArea(edges: .top)
                                }
                
                
            case .error( _):
               
                EmptyView()
                    .ignoresSafeArea(edges: .top)
            }
        }
      
    }
   
    
}

//Mark : Handle Car Proposal Response
private extension CarJourneyScreen {
    var proposalSection: some View {
        Group {
            //Mark : Handle Car Proposal Response
            
            switch viewModel.carState {
                
                
            case .idle,.loading :
               EmptyView()
                
            case .success( _):
                
              
                VStack(spacing : 16) {
                    
                   // statsSummaryView
                    StatsCarSummaryView(viewModel: viewModel, selectedPaymentStatus: $selectedPaymentStatus)
                   // searchAndFilterView
                    
                    SearchAndFilterView(viewModel: viewModel,
                                        searchText : $searchText ,
                                        showFilters : $showFilters,
                                        selectedPaymentStatus: $selectedPaymentStatus,
                                        onClearAll: clearAllFilters
                    )
                    
                    Group {
                        
                        if viewModel.filteredProposals.isEmpty {
                            //emptySearchView
                            EmptyCarSearchView(onClearAll: clearAllFilters)
                        } else {
                            //proposalsListView
                            
                            ProposalsListView(viewModel: viewModel)
                        }
                    }
                    
                }
              
                
            case .error(let networkError):
                
                
                ErrorStateView(networkError) {
                        viewModel.fetchAllData()  // ✅ Retry action
                    }
   
            }
            
            
        }
    }
}


// MARK: - Pinned Header Section
private extension CarJourneyScreen {
    var pinnedHeader: some View {
   
        VStack(spacing: 0) {
            
            HStack {
                Text("Your Car Journeys")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                
                // ✅ NOW WORKING: Button appears based on collapse progress
                if collapseProgress > 0.8 {
                    Button {
                        showFilters.toggle()
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .font(.system(size: 18))
                            .foregroundColor(.blue)
                    }
                    .transition(.opacity)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background(
                Color(UIColor.systemBackground)
                    .shadow(color: .black.opacity(collapseProgress > 0.3 ? 0.1 : 0),
                            radius: 3, y: 2)
            )
        }
        .background(Color(UIColor.systemGray6))
        .animation(.easeInOut(duration: 0.2), value: collapseProgress)
        
    }
    
    
    // MARK: - Placeholder Banner View
    private struct EmptyBannerPlaceholder: View {
        var body: some View {
            ZStack {
                LinearGradient(
                    colors: [.blue.opacity(0.2), .purple.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                VStack {
                    Image(systemName: "car.circle")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                    Text("No Active Banners")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
    
    // MARK: - Collapsing Banner View
    private struct CollapsingBannerView: View {
        let banners: [Banner]
        let scrollOffset: CGFloat
        let maxHeight: CGFloat
        let minHeight: CGFloat
        
        var body: some View {
            GeometryReader { geo in
               // let minY = geo.frame(in: .global).minY
                
                // ✅ FIXED: Use the same calculation as working example
               // let headerHeight = max(minHeight, maxHeight + minY)
                
                let minY = geo.frame(in: .named("scroll")).minY   // ✅ use same coordinate space
                
                let headerHeight = max(minHeight, maxHeight + minY)
                
                CustomCarouselView(banners: banners)
                    .frame(height: headerHeight)
                    .clipped()
                    .overlay(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                .black.opacity(0.3),
                                .black.opacity(0.1),
                                .clear
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .offset(y: -minY) // ✅ ** VIP,IMPORTANT: This keeps it pinned at top
                // ✅ COMMITED: report the actual headerHeight from INSIDE the collapsing geometry
                    .background(
                        Color.clear
                            .preference(key: BannerHeightPreferenceKey.self, value: headerHeight)
                    )
            }
            .frame(height: maxHeight) // Reserve initial space
        }
    }
    
    
    // MARK: - Preference Keys
    private struct ScrollOffsetPreferenceKey: PreferenceKey {
        static var defaultValue: CGFloat = 0
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) { value = nextValue() }
    }

    private struct BannerHeightPreferenceKey: PreferenceKey {
        static var defaultValue: CGFloat = 0
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) { value = nextValue() }
    }
}


#Preview {
    
    let container = PreviewDependencies.container
    //CarJourneyContentView(carVM: container.makeCarViewModel())
    CarJourneyScreen(viewModel: container.makeCarViewModel())
    
}

#Preview {
    
    let container = PreviewDependencies.container
    //CarJourneyContentView(carVM: container.makeCarViewModel())
    CarJourneyScreen(viewModel: container.makeCarViewModel())
    
}
