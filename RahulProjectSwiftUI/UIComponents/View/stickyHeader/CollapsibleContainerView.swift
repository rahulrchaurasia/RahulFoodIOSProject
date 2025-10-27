//
//  CollapsibleContainerView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 22/10/25.
//

import SwiftUI
// MARK: - 2. Collapsible Container View (Improved)

// MARK: - 2. Collapsible Container View (FIXED)
struct CollapsibleContainerView<Content: View>: View {
    let headerHeightPercentage: CGFloat
    let size: CGSize
    let safeArea: EdgeInsets
    let content: Content
    
    @State private var scrollOffset: CGFloat = 0
    
    private var minHeaderHeight: CGFloat { 88 + safeArea.top }
    private var maxHeaderHeight: CGFloat { size.height * headerHeightPercentage }
    
    init(headerHeightPercentage: CGFloat,
         size: CGSize,
         safeArea: EdgeInsets,
         @ViewBuilder content: () -> Content) {
        self.headerHeightPercentage = headerHeightPercentage
        self.size = size
        self.safeArea = safeArea
        self.content = content()
    }

    var body: some View {
        ZStack(alignment: .top) {
            // Scroll Content (FIXED)
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // Top spacer for header space - THIS WAS WRONG
                    Color.clear
                        .frame(height: maxHeaderHeight) // Use full max height, not the difference
                    
                    // Content with scroll tracking
                    content
                        .background(
                            GeometryReader { proxy in
                                Color.clear
                                    .preference(
                                        key: ScrollOffsetPreferenceKey.self,
                                        value: proxy.frame(in: .named("scrollView")).minY
                                    )
                            }
                        )
                }
            }
            .coordinateSpace(name: "scrollView")
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                // FIXED: Proper scroll offset calculation
                let offset = value
                scrollOffset = offset > 0 ? 0 : -offset
                print("Scroll offset: \(scrollOffset)") // Debug print
            }
            
            // Sticky Header
            StickyHeaderView2(
                size: size,
                safeArea: safeArea,
                headerHeightPercentage: headerHeightPercentage, scrollOffset: $scrollOffset
            )
        }
    }
}
