//
//  NavigationDestination.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 23/04/25.
//

import Foundation

import SwiftUI


protocol NavigationDestination {
    
    associatedtype Destination: View
       // var title: String { get }
    @ViewBuilder var destinationView: Destination { get }
    
}





