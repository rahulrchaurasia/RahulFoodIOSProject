//
//  FilterChip.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 10/10/25.
//

import SwiftUICore
import SwiftUI


struct FilterChip: View {
    let title: String
    let systemImage: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: systemImage)
                    .font(.caption2)
                Text(title)
                    .font(.caption)
                Image(systemName: "xmark.circle.fill")
                    .font(.caption2)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color.blue.opacity(0.1))
            .foregroundColor(.blue)
            .cornerRadius(12)
        }
    }
}

#Preview {
    
    
    //    FilterChip(title: "Data", isSelected: true) {
    //
    //        print("Slected data")
    //    }
    
 
    FilterChip(title: "Data", systemImage: "house") {
      
        print("Slected data")
    }
}
