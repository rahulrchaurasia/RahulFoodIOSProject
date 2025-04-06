//
//  CarJourneyContentView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 06/04/25.
//

import SwiftUI

struct CarJourneyContentView: View {
    var body: some View {
            VStack {
                Text("Car Journey")
                    .font(.largeTitle)
                    .padding()
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(UIColor.systemGray6))
        }
}

#Preview {
    CarJourneyContentView()
}
