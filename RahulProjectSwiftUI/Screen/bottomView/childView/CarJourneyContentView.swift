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
                ZStack {
                    Color(UIColor.systemGray4).ignoresSafeArea()
                    
                    CarJourneyScreen(viewModel: carVM)
                }
        }
}

#Preview {
    
    let container = PreviewDependencies.container
    
    CarJourneyContentView(carVM: container.makeCarViewModel())
    
}
