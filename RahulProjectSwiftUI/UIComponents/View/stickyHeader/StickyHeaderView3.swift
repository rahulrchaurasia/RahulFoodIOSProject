//
//  StickyHeaderView3.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 22/10/25.
//

import SwiftUI


// MARK: - 3. Sticky Header View (The Collapsing Header)
struct StickyHeaderView3: View {
    let size: CGSize
    let safeArea: EdgeInsets
    let percentageHeight: CGFloat
    
    @Binding var contentOffset: CGFloat // The distance scrolled down (0...max)

    private var minHeight: CGFloat { 44 + safeArea.top }
    
    // Calculate current height (Starts at max height and shrinks to min height)
    private var currentHeight: CGFloat {
        let maxHeight = size.height * percentageHeight
        let collapseRange = maxHeight - minHeight
        
        // Offset is negative when scrolling down in this calculation, so we use subtraction
        return max(minHeight, maxHeight - contentOffset)
    }

    // Collapse progress for fading in background/title
    private var progress: CGFloat {
        let maxHeight = size.height * percentageHeight
        let collapseRange = maxHeight - minHeight
        return min(1, max(0, contentOffset / collapseRange))
    }
    
    init(size: CGSize,
         safeArea: EdgeInsets,
         contentOffset: Binding<CGFloat>,
         percentageHeight: CGFloat) {
        self.size = size
        self.safeArea = safeArea
        self._contentOffset = contentOffset
        self.percentageHeight = percentageHeight
    }
    
    var body: some View {
        // Use a clean VStack for layering content
        VStack(spacing: 0) {
            
            // MARK: - Top Navigation Bar (Fixed to Safe Area)
            HStack(alignment: .top) {
                // Back Button (Always visible and positioned correctly)
                Image(systemName: "arrow.left")
                    .imageScale(.large)
                    .foregroundStyle(.white) // Use .white or a color that contrasts with the initial header
                    .padding(.top, safeArea.top + 12)
                    .opacity(1 - progress) // Fades out as it collapses
                
                Spacer()
                
                // Collapsed Title (Fades in when header is small)
                Text("Succeed")
                    .font(.headline).bold()
                    .foregroundStyle(.primary)
                    .padding(.top, safeArea.top + 12)
                    .opacity(progress) // Fades in when collapsed
                
                Spacer()
            }
            .padding(.horizontal)
            // Use the top part of the background only for the navigation content
            .frame(height: minHeight)
            .offset(y: -safeArea.top) // Move content up to align properly with the new minHeight
            
            // MARK: - Collapsible Content (Title/Subtitle)
            VStack(alignment: .leading, spacing: 6) {
                Text("Succeed")
                    .font(.title.bold()).foregroundStyle(.blue)
                    .opacity(1 - progress) // Fades out as it collapses
                
                Text("IOS Developer")
                    .foregroundStyle(.secondary)
                    .opacity(1 - progress) // Fades out as it collapses
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            // Push content down by the current offset
            .padding(.bottom, max(10 - contentOffset, 0))
            
            Spacer()
        }
        .frame(height: currentHeight) // Apply the dynamic height
        // Background layer: UltraThinMaterial for effect, opacity for fade
        .background(
            Rectangle()
                .fill(.ultraThinMaterial)
                .opacity(progress) // Fades in as it collapses
        )
        // Background layer: Solid color/image for expanded state
        .background(
            Image("denver")
                .resizable()
                .scaledToFill()
        )
        .clipped()
    }
}
//#Preview {
//    StickyHeaderView3()
//}
