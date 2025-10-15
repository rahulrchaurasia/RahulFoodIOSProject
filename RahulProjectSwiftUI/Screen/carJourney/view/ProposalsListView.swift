//
//  ProposalsListView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 14/10/25.
//

import SwiftUI

struct ProposalsListView: View {
    
    @ObservedObject var viewModel : CarViewModel
    var body: some View {
       
        LazyVStack(spacing: 12) {
            ForEach(viewModel.filteredProposals) { proposal in
                ProposalCard(proposal: proposal)
                    .padding(.horizontal)
            }
        }
        .padding(.vertical, 8)
    }
}

/*
 In your preview

 Because when your preview runs in Xcode, SwiftUI does not automatically call .task or onAppear() lifecycle methods like it does in a real app.

 Your CarViewModel starts empty — no banners, no proposals — because nothing triggers the async fetch.

 So if you just do this:

 ProposalsListView(viewModel: viewModel)


 then viewModel.filteredProposals will be empty, and your preview will show a blank list.

 ✅ Fix: manually trigger the data fetch

 By adding:

 .task { await viewModel.fetchAllData() }


 you’re telling the preview to:

 Run the async fetch (fetchAllData()),

 Populate mock proposals and banners,

 Then re-render the preview with actual content.

 That way you can see how your UI looks with real data, not an empty state.
 */
#Preview {
    
    let container = PreviewDependencies.container
    let viewModel = container.makeCarViewModel()


    ProposalsListView(viewModel: viewModel)
        .task { await viewModel.fetchAllData()
        }
}
