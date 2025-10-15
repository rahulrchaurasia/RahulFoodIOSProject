//
//  DetailRow.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 10/10/25.
//

import SwiftUI

struct DetailRow: View {
    
    let icon: String
        let title: String
        let value: String?
    
    
    var body: some View {
        
        
        HStack(spacing:4) {
            
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(width: 20)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(value ?? "N/A")  // Show N/A if value is nil
                .font(.caption)
                .fontWeight(.medium)
                .lineLimit(1)
                .padding(.leading,8)
            
            
            Spacer()
        }
    }
}

#Preview {
    DetailRow(icon: "car.rear", title: "title Data", value: "value details data")
}
