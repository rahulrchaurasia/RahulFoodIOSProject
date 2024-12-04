//
//  Double+Extension.swift
//  SwiftUIDemo
//
//  Created by Rahul Chaurasia on 08/10/23.
//

import Foundation



extension Double {
    func formatToTwoDecimalPlaces() -> Double {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2

        if let formattedString = formatter.string(from: NSNumber(value: self)),
           let formattedDouble = formatter.number(from: formattedString)?.doubleValue {
            return formattedDouble
        }

        return self // Return the original value in case of any errors
    }
}

