//
//  Date+Extension.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 21/11/25.
//

import Foundation



extension Date {
    var toDOBString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: self)
    }
}


