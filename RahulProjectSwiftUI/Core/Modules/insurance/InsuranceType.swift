//
//  InsuranceType.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 18/12/25.
//

import Foundation


enum InsuranceType: String, CaseIterable, Identifiable {
    case car = "Car"
    case bike = "Bike"
    case health = "Health"
    
    var id: String { self.rawValue }
}
