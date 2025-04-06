//
//  TransactionContentView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 06/04/25.
//

import SwiftUI

struct TransactionContentView: View {
    var body: some View {
            VStack {
                Text("Transaction")
                    .font(.largeTitle)
                    .padding()
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(UIColor.systemGray6))
        }
}

#Preview {
    TransactionContentView()
}
