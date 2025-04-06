//
//  OnboardingPageView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 02/01/25.
//

import SwiftUI

struct OnboardingPageView: View {
    let item: OnboardingItem
    
    var body: some View {
            VStack(spacing: 20) {
                Image(item.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                
                Text(item.title)
                    .font(.title)
                    .bold()
                
                Text(item.subtitle)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
            }
        }
}

#Preview {
    
    
    let onboardingObj =  OnboardingItem(imageName: "a1", title: "Headline", subtitle: "Data Description")
    OnboardingPageView(item: onboardingObj)
}
