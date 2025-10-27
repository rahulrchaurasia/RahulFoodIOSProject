//
//  NotrificationList.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 21/10/25.
//

import SwiftUI

struct NotrificationList: View {
    var body: some View {
       
        ScrollView(showsIndicators : false){
            VStack(spacing :0){
                VStack(alignment: .leading, spacing: 12) {
                    
                    Text("SwiftUI Native Placeholder Example")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                    
                    Text("No external libraries required.")
                        .font(.largeTitle)
                    
                    Text("""
                               SwiftUI makes it super easy to show skeleton loaders using the redacted modifier. \
                               It’s clean, smooth, and requires no setup. You can toggle it dynamically during data fetches.
                               """)
                    .font(.largeTitle)
                    
                    Text("""
                               Combine this with .shimmering() (iOS 17+) for a premium look, \
                               or add your own gradient animation for earlier versions.
                               """)
                    .font(.largeTitle)
                    
                }
                .padding(.horizontal)
                .lineSpacing(0)
                .privacySensitive(true)
                .redacted(reason: .privacy)
                
                Text("SwiftUI Native Placeholder Example")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                
                Text("No external libraries required.")
                    .font(.title2)
                Text("No external libraries required.")
                    .font(.caption)
            }
           
        }
        
    }
}

#Preview {
    NotrificationList()
}
