//
//  StatusChip.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 10/10/25.
//

import SwiftUI

struct StatusChip: View {
    
    let status: String
        let count: Int
        let isSelected: Bool
        let action: () -> Void
    
    
    var body: some View {
            Button(action: action) {
                HStack(spacing: 6) {
                    Text(status)
                        .font(.caption)
                        .fontWeight(.medium)
                    
                    Text("\(count)")
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(isSelected ? Color.blue.opacity(0.2) : Color.clear)
                        .foregroundColor(.blue)
                        .cornerRadius(4)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.blue.opacity(0.2) : Color(.systemGray6))
                .foregroundColor(isSelected ? .blue : .primary)
                .cornerRadius(15)
            }
        }
}

#Preview {
    StatusChip(status: "Available", count: 3, isSelected: false){
        
        print("Selected")
    }
}
