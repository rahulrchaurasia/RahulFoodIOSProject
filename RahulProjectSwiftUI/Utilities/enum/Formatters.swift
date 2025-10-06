//
//  Formatters.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 30/09/25.
//
import Foundation


enum Formatters {
    static let itemFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .short
        return f
    }()
}
