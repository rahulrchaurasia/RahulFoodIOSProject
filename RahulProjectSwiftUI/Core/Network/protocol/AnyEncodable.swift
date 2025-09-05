//
//  AnyEncodable.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 30/08/25.
//

import Foundation

struct AnyEncodable: Encodable {
    private let encodeFunc: (Encoder) throws -> Void
    
    init<T: Encodable>(_ value: T) {
        self.encodeFunc = value.encode
    }
    
    func encode(to encoder: Encoder) throws {
        try encodeFunc(encoder)
    }
}
