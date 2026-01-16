//
//  UserConstantRequest.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 12/01/26.
//

import Foundation

// MARK: - Request (Must be Encodable for the body)
struct UserConstantRequest: Encodable {
    let appVersion: String
    let deviceCode: String
    let fbaid: String
    let ssid: String
    
    enum CodingKeys: String, CodingKey {
        case appVersion = "app_version"
        case deviceCode = "device_code"
        case fbaid = "fbaid"
        case ssid = "ssid"
      
    }
}
