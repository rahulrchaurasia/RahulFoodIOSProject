//
//  ContentView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 13/11/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Text("Hello, world!")
            
            if #available(iOS 16.0, *) {
                ProfileView1()
            } else {
                // Fallback on earlier versions
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
