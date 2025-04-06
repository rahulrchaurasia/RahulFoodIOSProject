//
//  Trimmed.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 03/04/25.
//

import Foundation


@propertyWrapper
struct Trimmed {
    private var value: String = ""

    var wrappedValue: String {
        get { value }
        set { value = newValue.trimmingCharacters(in: .whitespacesAndNewlines) }
    }

    init(wrappedValue: String) {
        self.wrappedValue = wrappedValue.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}


/*
 
 struct Form {
     @Trimmed var username: String
 }

 var form = Form(username: "   SwiftUser  ")
 print(form.username) // Output: "SwiftUser"

 */
