//
//  CustomCarouselView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 06/10/25.
//

import SwiftUI

import SwiftUI

// This is the preferred approach for its simplicity and reliability.

/*
 🔹 Why enumerated() is used

 displayBanners is just an array of Banner.

 If you use ForEach(displayBanners, id: \.id), you only get the banner itself.

 But we also need the index because we are using TabView(selection:).

 TabView(selection:) requires each child to have a .tag()

 .tag() must be unique and usually represents the index or identifier.

 So we need the index to assign tag(index).

 enumerated() returns (index, element) pairs

 This gives us both the index (for .tag()) and the banner (for the content).
 */

import SwiftUI
import Combine
import Kingfisher

struct CustomCarouselView: View {
    let banners: [Banner]
    
    @State private var currentIndex = 1
    @State private var lastIndex = 1
    @State private var isManualScrolling = false
    @State private var resumeTimerWorkItem: DispatchWorkItem?
    @State private var timerSubscription: Cancellable?
    
    // MARK: - Extended banners for infinite loop
    private var displayBanners: [Banner] {
        guard !banners.isEmpty,
              let first = banners.first,
              let last = banners.last else { return [] }
        return [last] + banners + [first]
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 12) {
            if !banners.isEmpty {
    
                TabView(selection: $currentIndex) {
                    
                    /*
                     We use enumerated() so that we get both the banner and its index, which is necessary for:
                     
                     Assigning .tag(index) in TabView(selection:)
                     
                     Handling infinite scroll logic with indices
                     
                     It’s the cleanest and safest approach for an infinite carousel.
                     
                     */
                    
                    ForEach(Array(displayBanners.enumerated()), id: \.offset) { index, banner in
                        bannerView(banner, index: index)
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: 200)
                .clipped()
                .gesture(swipeGesture) // Handle manual swipes cleanly
                
                // iOS 16 safe onChange
                .onChange(of: currentIndex) { newValue in
                    handleIndexChange(from: lastIndex, to: newValue)
                    lastIndex = newValue
                }
                
                // MARK: - Lifecycle & Timer Control
                .onAppear {
                    setupInitialPosition()
                    startTimer()
                }
                .onDisappear {
                    stopTimer()
                    resumeTimerWorkItem?.cancel()
                }
                
                // MARK: - Page Indicators
                pageIndicators
            } else {
                emptyStateView
            }
        }
    }
    
    // MARK: - Subviews
    
    private func bannerView(_ banner: Banner, index: Int) -> some View {
        
        
        KFImage(URL(string: banner.imageUrl))
               .placeholder {
                   ProgressView()
                       .frame(maxWidth: .infinity, maxHeight: .infinity)
                       .background(Color.gray.opacity(0.3))
               }
               .resizable()
               .aspectRatio(contentMode: .fill)
               .clipped()
               .contentShape(Rectangle())
               .onTapGesture {
                   handleBannerTap(banner)
               }
        
        // handleBannerTap(banner)
    }
    
    private var pageIndicators: some View {
        HStack(spacing: 8) {
            ForEach(banners.indices, id: \.self) { index in
                Capsule()
                    .fill(index == actualCurrentIndex ? Color.blue : Color.gray.opacity(0.5))
                    .frame(width: index == actualCurrentIndex ? 20 : 8, height: 8)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: actualCurrentIndex)
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack {
            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 40))
                .foregroundColor(.gray)
            Text("No Banners Available")
                .font(.headline)
            Text("Check back later for new content")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(height: 200)
    }
    
    // MARK: - Gesture Handling
    
    private var swipeGesture: some Gesture {
        DragGesture()
            .onChanged { _ in handleSwipeStarted() }
            .onEnded { _ in handleSwipeEnded() }
    }
    
    // MARK: - Helpers
    
    private var actualCurrentIndex: Int {
        guard !banners.isEmpty else { return 0 }
        if currentIndex == 0 {
            return banners.count - 1
        } else if currentIndex == displayBanners.count - 1 {
            return 0
        } else {
            return currentIndex - 1
        }
    }
    
    private func setupInitialPosition() {
        guard !banners.isEmpty else { return }
        currentIndex = 1
        lastIndex = 1
    }
    
    private func handleIndexChange(from oldIndex: Int, to newIndex: Int) {
        guard !banners.isEmpty else { return }
        let totalCount = displayBanners.count
        
        // Handle looping without animation flicker
        if newIndex == 0 {
            currentIndex = totalCount - 2
            lastIndex = totalCount - 2
        } else if newIndex == totalCount - 1 {
            currentIndex = 1
            lastIndex = 1
        }
    }
    
    // MARK: - Timer Management
    
    private func startTimer() {
        stopTimer() // cancel any existing timer
        
        let timer = Timer.publish(every: 3.0, on: .main, in: .common).autoconnect()
        timerSubscription = timer.sink { _ in
            handleTimerTick()
        }
    }
    
    private func stopTimer() {
        timerSubscription?.cancel()
        timerSubscription = nil
    }
    
    private func handleTimerTick() {
        guard !banners.isEmpty, !isManualScrolling, timerSubscription != nil else { return }
        withAnimation(.easeInOut(duration: 0.5)) {
            currentIndex += 1
        }
    }
    
    // MARK: - Swipe Control
    
    private func handleSwipeStarted() {
        guard !isManualScrolling else { return }
        isManualScrolling = true
        resumeTimerWorkItem?.cancel()
    }
    
    private func handleSwipeEnded() {
        resumeTimerWorkItem?.cancel()
        let workItem = DispatchWorkItem {
            isManualScrolling = false
        }
        resumeTimerWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: workItem)
    }
    
    // MARK: - Actions
    
    private func handleBannerTap(_ banner: Banner) {
        print("Banner tapped: \(banner.title)")
        // Add navigation or action if needed
    }
}




#Preview {
    
    let sampleBanners = [
            Banner(id: "1", title: "Nature's Beauty", imageUrl: "https://picsum.photos/id/12/600/400"),
            Banner(id: "2", title: "City Life", imageUrl: "https://picsum.photos/id/45/600/400"),
            Banner(id: "3", title: "Abstract Art", imageUrl: "https://picsum.photos/id/52/600/400"),
            Banner(id: "4", title: "Mountain View", imageUrl: "https://picsum.photos/id/62/600/400")
        ]
        
        // You can also test the empty state easily.
        let emptyBanners: [Banner] = []
        
        return VStack(spacing: 50) {
            // Preview with sample data
            CustomCarouselView(banners: sampleBanners)
            
            // Preview for the empty state
            CustomCarouselView(banners: emptyBanners)
        }
        .padding()
    
}
