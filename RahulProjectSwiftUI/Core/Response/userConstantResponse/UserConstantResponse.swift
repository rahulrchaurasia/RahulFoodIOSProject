//
//  UserConstantResponse.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 12/01/26.
//

import Foundation



// MARK: - Response (Directly used in View)
import Foundation

struct UserConstantResponse: Decodable {
    let message: String?
    let status: String?
    let masterData: UserConstantData? // Optional, will be nil if failed

    enum CodingKeys: String, CodingKey {
        case message = "Message"
        case status = "Status"
        case masterData = "MasterData"
    }
    
    // ✅ Custom Decoding Logic
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // 1. Decode Status & Message first
        self.message = try container.decodeIfPresent(String.self, forKey: .message)
        self.status = try container.decodeIfPresent(String.self, forKey: .status)
        
        // 2. Logic: Check if Status is success (Case Insensitive)
        // API sends "success" or "Success", so we lowercase it to be safe
        let isSuccess = (status?.lowercased() == "success")
        
        if isSuccess {
            // 3. Only try to decode object if it is a Success
            self.masterData = try container.decodeIfPresent(UserConstantData.self, forKey: .masterData)
        } else {
            // 4. If Failure, ignore MasterData (even if it's []), just set nil
            self.masterData = nil
        }
    }
}


// The inner object from the JSON
struct UserConstantData: Decodable {
    let pospDesignation: String?
    let pospPhotoURL: String?
//    let fbaId: Int?
//    let managerName: String?
//    let supportMobile: String?
    
    enum CodingKeys: String, CodingKey {
        // We still map keys to keep Swift code clean (camelCase)
        case pospDesignation = "pospselfdesignation"
        case pospPhotoURL = "pospselfphoto"
//        case fbaId = "FBAId"
//        case managerName = "ManagName"
//        case supportMobile = "SuppMobile"
    }
}
