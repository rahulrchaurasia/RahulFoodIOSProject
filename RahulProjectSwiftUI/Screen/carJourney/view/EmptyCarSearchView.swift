//
//  EmptyCarSearchView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 14/10/25.
//

import SwiftUI

struct EmptyCarSearchView: View {
    
    var onClearAll:   (()-> Void)?
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 50))
                .foregroundColor(.secondary)
            
            Text("No matching proposals")
                .font(.headline)
            
            Text("Try adjusting your search criteria")
                .font(.body)
                .foregroundColor(.secondary)
            
            Button("Clear Search") {
                onClearAll?()
            }
            .buttonStyle(.bordered)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .padding(.horizontal)
        .padding(.top, 20)
    }
}

#Preview {
    EmptyCarSearchView()
}
