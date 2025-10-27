//
//  NotificationListView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 22/10/25.
//

import SwiftUI

struct NotificationListView: View {
    var body: some View {
            LazyVStack(spacing: 16) {
                ForEach(0..<20, id: \.self) { index in
                    NotificationCard(index: index)
                }
            }
            .padding(.top, 16)
        }
}

#Preview {
    NotificationListView()
}


struct NotificationCard: View {
    let index: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                Circle()
                    .fill(Color.blue.opacity(0.8))
                    .frame(width: 44, height: 44)
                    .overlay(
                        Image(systemName: "bell.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Notification #\(index + 1)")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("This is a detailed notification description that provides context and information to the user.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                Text("2h ago")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Divider()
        }
        .padding(.vertical, 8)
    }
}
