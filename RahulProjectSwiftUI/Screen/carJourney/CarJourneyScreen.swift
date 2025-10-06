//
//  CarJourneyScreen.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 03/10/25.
//

import SwiftUI

struct CarJourneyScreen: View {
    
    // 1. The view now holds a StateObject for the ViewModel
    @ObservedObject  var viewModel : CarViewModel
    
    
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading...")
            } else {
                TabView {
                    ForEach(viewModel.banners) { banner in
                        AsyncImage(url: URL(string: banner.imageUrl)) { img in
                            img.resizable()
                        } placeholder: {
                            Color.gray.opacity(0.3)
                        }
                        .scaledToFill()
                        .tag(banner.id)
                    }
                }
                .tabViewStyle(.page)
            }
        }
        .task {
            await viewModel.fetchBanners()
        }
    }
}

#Preview {
    
    let container = PreviewDependencies.container
    //CarJourneyContentView(carVM: container.makeCarViewModel())
    CarJourneyScreen(viewModel: container.makeCarViewModel())
}
