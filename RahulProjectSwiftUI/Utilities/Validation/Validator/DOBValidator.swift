//
//  DOBValidator.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 24/11/25.
//

import Foundation


struct DOBValidator {

    static func validateDOB(_ dobString: String,
                            minAge: Int = 18,
                            maxAge: Int = 100) -> DOBValidationResult {

        guard dobString.count == 10 else {
            return .invalid("Incomplete date")
        }

        let parts = dobString.split(separator: "/")
        guard parts.count == 3 else { return .invalid("Invalid format") }

        guard let day = Int(parts[0]),
              let month = Int(parts[1]),
              let year = Int(parts[2]) else {
            return .invalid("Invalid numbers")
        }

        // Basic month check
        guard (1...12).contains(month) else { return .invalid("Invalid month") }

        let calendar = Calendar.current

        // REAL DATE VALIDATION (handles leap years)
        var comp = DateComponents()
        comp.day = day
        comp.month = month
        comp.year = year

        guard let dobDate = calendar.date(from: comp) else {
            return .invalid("Invalid date")
        }

        // Age validation
        let currentDate = Date()
        let age = calendar.dateComponents([.year], from: dobDate, to: currentDate).year ?? 0

        if age < minAge {
            return .invalid("You must be at least \(minAge)")
        }

        if age > maxAge {
            return .invalid("Age cannot exceed \(maxAge)")
        }

        return .valid(dobDate)
    }
}

enum DOBValidationResult {
    case valid(Date)
    case invalid(String)
}
