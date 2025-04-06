//
//  UserResponse.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 01/04/25.
//

import Foundation


struct UserResponse: Codable {
    let message: String
    let status: String
    let statusNo: Int
    let masterData: [User]
    
    enum CodingKeys: String, CodingKey {
        case message = "Message"
        case status = "Status"
        case statusNo = "StatusNo"
        case masterData = "MasterData"
    }
}

struct User: Identifiable, Codable {
    let id: Int
    let name: String
    let mobile: String
    let email: String
    let address: Address
    let gender: String
    let dob: String
    let occupation: String
    let company: String
    let maritalStatus: String
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, mobile, email, address, gender, dob, occupation, company
        case maritalStatus = "marital_status"
        case createdAt = "created_at"
    }
}

struct Address: Codable {
    let zip: String
    let city: String
    let state: String
    let street: String
    let country: String
}
