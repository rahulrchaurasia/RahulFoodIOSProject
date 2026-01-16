//
//  AgentListResponseDTO.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 06/01/26.
//

import Foundation


struct AgentListResponseDTO1 : Decodable {
    
      let Message: String
        let Status: String
        let StatusNo: Int
        let MasterData: [AgentDTO]
}


struct AgentDTO1: Decodable {
    let AgentId: Int
    let Agent_Code: String
    let UId: String
    let FullName: String
    let EmailID: String
    let MobileNumber: String
    let isactive: Int
    let EMPType: String
    let Created_on: String
    let Wallet_Amount: String
}
