//
//  TransactionRow.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 07/10/25.
//

import SwiftUI

struct TransactionRow: View {
    
    let index: Int
    
    var body: some View {
            HStack {
                VStack(alignment: .leading) {
                    Text("Transaction #\(index + 1)")
                        .font(.headline)
                    Text("Today, 10:3\(index) AM")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text("$\(index + 1)9.99")
                    .font(.headline)
                    .foregroundColor(.green)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
}

#Preview {
    
    TransactionRow(index: 3)
}
