//
//  CollapsingHeaderView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 17/04/25.
//

import SwiftUI

struct CollapsingHeaderView: View {
    // Threshold for when title should start showing
    private let titleVisibilityThreshold: CGFloat = 80
    
    // Used to track scroll position
    @State private var scrollOffset: CGFloat = 0
    
    // For reading the scroll offset
    private let offsetKey = "scrollOffset"
    
    
    
    
    var body: some View {
        ScrollView {
            ZStack(alignment: .top) {
                // Header image that will parallax and fade
                GeometryReader { geo in
                    Image("a1")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geo.size.width, height: 200 + (scrollOffset > 0 ? scrollOffset : 0))
                        .clipped()
                        .offset(y: scrollOffset > 0 ? -scrollOffset : 0)
                        .opacity(calculateImageOpacity())
                }
                .frame(height: 200)
                
                // Main Content
                VStack(spacing: 16) {
                    // Spacer to push content below header
                    Color.clear.frame(height: 200)
                    
                    // Content items
                    ForEach(0..<20) { index in
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            
                            Text("Item \(index + 1)")
                                .font(.headline)
                            
                            Spacer()
                            
                            Text("Detail")
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                    }
                }
                .padding(.horizontal)
                .background(
                    // Scroll offset reader
                    GeometryReader { geo in
                        Color.clear.preference(
                            key: ViewOffsetKey.self,
                            value: geo.frame(in: .global).minY
                        )
                    }
                )
                .onPreferenceChange(ViewOffsetKey.self) { value in
                    scrollOffset = value
                }
                
                // Toolbar that appears when scrolling
                VStack {
                    HStack {
                        Button(action: {
                            // Back action
                        }) {
                            Image(systemName: "arrow.left")
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Color.black.opacity(0.4))
                                .clipShape(Circle())
                        }
                        
                        Spacer()
                        
                        // Title that appears when scrolling
                        if scrollOffset < -titleVisibilityThreshold {
                            Text("My Header Title")
                                .font(.headline)
                                .foregroundColor(.primary)
                                .transition(.opacity)
                                .animation(.easeInOut, value: scrollOffset < -titleVisibilityThreshold)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            // Menu action
                        }) {
                            Image(systemName: "ellipsis")
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Color.black.opacity(0.4))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal)
                    .frame(height: 60)
                    .background(scrollOffset < -titleVisibilityThreshold ? Color.white : Color.clear)
                    .animation(.easeInOut, value: scrollOffset < -titleVisibilityThreshold)
                }
            }
        }
        .edgesIgnoringSafeArea(.top)
    }
    
    private func calculateImageOpacity() -> Double {
        // Full opacity at top, fading as user scrolls down
        let opacity = 1.0 + Double(scrollOffset) / 200.0
        return max(min(opacity, 1.0), 0.3) // Clamp between 0.3 and 1.0
    }
}

// Helper to read scroll position
struct ViewOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}


#Preview {
    CollapsingHeaderView()
}
