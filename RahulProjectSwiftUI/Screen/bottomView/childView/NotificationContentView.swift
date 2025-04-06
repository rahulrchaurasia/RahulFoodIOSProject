//
//  NotificationContentView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 06/04/25.
//

import SwiftUI

struct NotificationContentView: View {
    var body: some View {
            VStack {
                Text("Notifications")
                    .font(.largeTitle)
                    .padding()
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(UIColor.systemGray6))
        }
}

#Preview {
    NotificationContentView()
}
