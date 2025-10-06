//
//  JourneyStep.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 03/10/25.
//

import Foundation


// Model for the items in the list below the carousel
struct JourneyStep: Identifiable {
    let id = UUID()
    let iconName: String
    let title: String
    let description: String
}
