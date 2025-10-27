//
//  StickyHeaderView2.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 22/10/25.
//

import SwiftUI

// MARK: - Refined Sticky Header View


struct StickyHeaderView2: View {
    let size: CGSize
    let safeArea: EdgeInsets
    let headerHeightPercentage: CGFloat
    
    @Binding var scrollOffset: CGFloat
    
    private var minHeight: CGFloat { 88 + safeArea.top }
    private var maxHeight: CGFloat { size.height * headerHeightPercentage }
    private var collapseRange: CGFloat { maxHeight - minHeight }
    
    // Current header height (FIXED)
    private var currentHeight: CGFloat {
        let targetHeight = maxHeight - scrollOffset
        return max(minHeight, targetHeight)
    }
    
    // Progress from 0 (expanded) to 1 (collapsed) - FIXED
    private var collapseProgress: CGFloat {
        guard collapseRange > 0 else { return 0 }
        let progress = scrollOffset / collapseRange
        return min(1, max(0, progress))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Navigation Bar (Fixed at top)
            HStack {
                // Back Button (FIXED background)
                Button(action: {}) {
                    ZStack {
                        if collapseProgress > 0.3 {
                            Circle()
                                .fill(.ultraThinMaterial)
                        }
                        
                        Image(systemName: "arrow.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(collapseProgress > 0.3 ? .primary : .white)
                    }
                    .frame(width: 44, height: 44)
                }
                
                Spacer()
                
                // Title in collapsed state
                if collapseProgress > 0.5 {
                    Text("Succeed")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .transition(.opacity)
                }
                
                Spacer()
                
                // More button (FIXED background)
                Button(action: {}) {
                    ZStack {
                        if collapseProgress > 0.3 {
                            Circle()
                                .fill(.ultraThinMaterial)
                        }
                        
                        Image(systemName: "ellipsis")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(collapseProgress > 0.3 ? .primary : .white)
                    }
                    .frame(width: 44, height: 44)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, safeArea.top)
            .padding(.bottom, 12)
            
            Spacer()
            
            // MARK: - Expandable Content
            if collapseProgress < 0.8 {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Succeed")
                        .font(.system(size: 34 - (14 * collapseProgress), weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("iOS Developer")
                        .font(.system(size: 18 - (6 * collapseProgress), weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                        .opacity(1 - collapseProgress)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
            }
        }
        .frame(height: currentHeight, alignment: .top)
        .background(
            // Background Image
            ZStack {
                Image("denver") // Make sure this image exists in your assets
                    .resizable()
                    .scaledToFill()
                    .frame(height: currentHeight)
                    .clipped()
                    .overlay(
                        LinearGradient(
                            colors: [.clear, .black.opacity(0.3)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                
                // Material overlay when collapsed
                Rectangle()
                    .fill(.regularMaterial)
                    .opacity(collapseProgress)
            }
        )
        .clipped()
        .animation(.interactiveSpring(response: 0.3, dampingFraction: 0.8), value: collapseProgress)
    }
}
//#Preview {
//    StickyHeaderView2()
//}
