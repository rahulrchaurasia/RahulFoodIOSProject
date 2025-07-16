//
//  OnboardingViewModel.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 30/12/24.
//

import Foundation
import SwiftUI

class OnboardingViewModel : ObservableObject {
    
    
    @Published var currentPage = 0
    
    //Mark: This sets the default value to false if there’s no existing value in UserDefaults for that key.
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
        
    
    // MARK: - Properties
        let items = [
            OnboardingItem(
                imageName: "a1",
                title: "Welcome",
                subtitle: "Discover amazing features"
            ),
            OnboardingItem(
                imageName: "a2",
                title: "Features",
                subtitle: "Everything you need"
            ),
            OnboardingItem(
                imageName: "a3",
                title: "Shopping",
                subtitle: "Let's get started!"
            ),
            OnboardingItem(
                imageName: "a4",
                title: "Ready",
                subtitle: "Let's get started!"
            )
        ]
    
    // MARK: - Computed Properties
        var isLastPage: Bool {
            currentPage == items.count - 1
        }
    
    
    // MARK: - Methods
        func nextPage() {
            if isLastPage {
                completeOnboarding()
            } else {
                currentPage += 1
            }
        }
    
       func skipOnboarding() {
            completeOnboarding()
        }
        
        func completeOnboarding() {
            hasSeenOnboarding = true
        }

}
