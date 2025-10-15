//
//  CarJourneyScreen.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 03/10/25.
//

import SwiftUI

    struct CarJourneyScreen: View {
        @ObservedObject var viewModel: CarViewModel
        @State private var showFilters = false
        @State private var selectedPaymentStatus: String? = nil
        @State private var searchText = ""
        
    
        
        var body: some View {
            ZStack{
                
                // Background
                Color(UIColor.systemGray6).ignoresSafeArea()
               
                ScrollView {
                    
                    VStack(spacing: 0){
  
                        bannerSection
                        
                        proposalSection
                               
                    }
                    //Mark : Handle Bannere Response
                    
                }
                
                
                // ✅ Modern approach - content automatically adjusts for safe area
                
//                .safeAreaInset(edge: .top, spacing: 0) {
//
//                    Color.clear.frame(height: 50) // Optional: Add custom header here
//                }
                
                if viewModel.isLoading{
                    
                    Color.black.opacity(0.2)
                        .ignoresSafeArea()
                    
                    ProgressView("Loading...")
                        .padding(.horizontal, 24)
                        .padding(.vertical, 16)
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                    
                }
                
              
            }
           
            .task {
                // Mark no await req bec in viewModel we used : var fetchBannerTask: Task<Void, Never>?
                viewModel.fetchAllData() // ✅ No await needed!
            }
            .onDisappear {
                viewModel.cancelAll() // ✅ Cleanup when view disappears
            }
            
            .sheet(isPresented: $showFilters) {
                FilterSheetView(selectedPaymentStatus: $selectedPaymentStatus , showFilters: $showFilters, viewModel: viewModel)
            }
        }
        
        
        private func clearAllFilters() {
            searchText = ""
            selectedPaymentStatus = nil
            viewModel.clearSearch()
        }
        
        
 }

private extension CarJourneyScreen {
    
    var bannerSection: some View {
        
        Group{
            
            switch viewModel.bannerState {
            case .idle, .loading:
                EmptyView()
            
            case .success(let banners):
                
                    VStack(spacing: 0) {
                        
                        CustomCarouselView(banners: banners)
                            .frame(height: 200)
                        // Additional sections below
                        Text("Your Car Journeys")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                            .padding(.top,16)
                    }
                
                
            case .error( _):
               
                EmptyView()
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
                    
                    if viewModel.filteredProposals.isEmpty {
                        //emptySearchView
                        EmptyCarSearchView(onClearAll: clearAllFilters)
                    } else {
                        //proposalsListView
                        
                        ProposalsListView(viewModel: viewModel)
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





#Preview {
    
    let container = PreviewDependencies.container
    //CarJourneyContentView(carVM: container.makeCarViewModel())
    CarJourneyScreen(viewModel: container.makeCarViewModel())
    
}
