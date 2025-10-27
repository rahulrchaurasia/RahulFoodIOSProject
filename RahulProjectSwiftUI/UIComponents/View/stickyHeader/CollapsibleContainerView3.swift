//
//  CollapsibleContainerView 2.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 22/10/25.
//

import SwiftUI
// MARK: - 2. Collapsible Container View (Manages Scroll & Offset)
struct CollapsibleContainerView3<Content: View>: View {
    let percentageHeight: CGFloat // Max header percentage
    let size: CGSize
    let safeArea: EdgeInsets
    let content: Content
    
    @State private var contentOffset: CGFloat = 0 // Tracks scroll distance
    
    // Note: Use minHeight = 44 + safeArea.top for standard iOS
    private var minHeight: CGFloat { 44 + safeArea.top }

    init(percentageHeight: CGFloat, size: CGSize, safeArea: EdgeInsets, @ViewBuilder content: () -> Content) {
        self.percentageHeight = percentageHeight
        self.size = size
        self.safeArea = safeArea
        self.content = content()
    }

    var body: some View {
        ZStack(alignment: .top) {
            
            ScrollView(showsIndicators: false) {
                
                VStack(spacing: 0) {
                    
                    // Invisible view to track scroll offset
                    Color.clear
                        .frame(height: 0)
                        .background(
                            GeometryReader { geo in
                                Color.clear
                                    // Use origin.y for simple scroll distance from top
                                    .preference(key: ContentOffsetKey.self, value: -geo.frame(in: .named("scrollView")).origin.y)
                            }
                        )
                    
                    content
                        // Add top padding equal to the max height to push content down
                        .padding(.top, size.height * percentageHeight)
                }
            }
            .coordinateSpace(name: "scrollView")
            .onPreferenceChange(ContentOffsetKey.self) { value in
                // Only track positive scroll values (scrolling up)
                self.contentOffset = max(0, value)
            }
            
            // The Sticky Header Overlay (Always on top)
            StickyHeaderView3(
                size: size,
                safeArea: safeArea,
                contentOffset: $contentOffset,
                percentageHeight: percentageHeight
            )
        }
    }
}
