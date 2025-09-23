//
//  SplashView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 10/09/25.
//


import SwiftUI

struct SplashView: View {
    @State private var logoScale: CGFloat = 0.6
    @State private var titleOpacity: Double = 0
    @State private var titleOffset: CGFloat = 50
    @State private var imageOpacity: Double = 0

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 24) {
                VStack {
                    Text("Let's get")
                        .font(.largeTitle.bold())
                        .foregroundColor(.black)
                        .opacity(titleOpacity)
                        .offset(y: titleOffset)

                    Text("Started.")
                        .font(.largeTitle.bold())
                        .foregroundColor(.orange)
                        .opacity(titleOpacity)
                        .offset(y: titleOffset)
                }

                Image("a7") // put in Assets.xcassets
                    .resizable()
                    .scaledToFit()
                    .frame(height: 250)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .scaleEffect(logoScale)
                    .opacity(imageOpacity)
            }
        }
        .onAppear {
            // Step 1: Animate text fade-in
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                titleOpacity = 1
                titleOffset = 0
            }

            // Step 2: Animate image after short delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                    logoScale = 1
                    imageOpacity = 1
                }
            }
        }
    }
}

#Preview {
    SplashView()
}
