//
//  StatusBadge.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 10/10/25.
//

import SwiftUI

struct StatusBadge: View {
    
    let status : String?
    
    private var statusColor : Color {
        
        switch status?.lowercased() {
            
        case "pending": return .orange
            
        case "approved","done", "success": return .green
            
        case "failed", "rejected": return .red
            
        default:
            return .gray
            
        }
    }
    
    private var displayText : String {
        
        status ?? "Unknown"  // Fallback if nil
    }
    
    var body: some View {
        
        Text(displayText)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(statusColor.opacity(0.2))
                    .foregroundColor(statusColor)
                    .cornerRadius(6)
        
    }
}

#Preview {
    StatusBadge(status: "Approved")
}
