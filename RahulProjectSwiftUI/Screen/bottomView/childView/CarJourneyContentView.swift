//
//  CarJourneyContentView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 06/04/25.
//

import SwiftUI

struct CarJourneyContentView: View {
    
    // Use ObservedObject since the view model is created at the parent level
    @ObservedObject var carVM: CarViewModel
    var body: some View {
            VStack {
                CarJourneyScreen(viewModel: carVM)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(UIColor.systemGray6))
        }
}

#Preview {
    
    let container = PreviewDependencies.container
    
    CarJourneyContentView(carVM: container.makeCarViewModel())
    
}
