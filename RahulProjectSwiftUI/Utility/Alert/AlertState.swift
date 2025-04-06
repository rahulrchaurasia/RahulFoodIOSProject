//
//  AlertState.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 03/04/25.
//

import Foundation


struct AlertState {
    var isPresented: Bool = false
    var title: String = ""
    var message: String = ""
    
    static var hidden: AlertState {
        return AlertState(isPresented: false)
    }
    
    static func error(message: String) -> AlertState {
        return AlertState(isPresented: true, title: "Error", message: message)
    }
    
    static func success(message: String) -> AlertState {
        return AlertState(isPresented: true, title: "Success", message: message)
    }
}
