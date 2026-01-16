//
//  AgentListResponse.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 06/01/26.
//


import Foundation

// MARK: - API Response Model (DTO)
struct AgentListResponse: Codable {
    let message: String?
    let status: String?
    let masterData: [AgentDTO]?

    enum CodingKeys: String, CodingKey {
        case message = "Message"
        case status = "Status"
        case masterData = "MasterData"
    }
}

struct AgentDTO: Codable {
    let agentId: Int
    let fullName: String?
    let email: String?
    let mobile: String?
    let uid: String?
    
    // Map JSON keys to Swift property names
    enum CodingKeys: String, CodingKey {
        case agentId = "AgentId"
        case fullName = "FullName"
        case email = "EmailID"
        case mobile = "MobileNumber"
        case uid = "UId"
    }
}