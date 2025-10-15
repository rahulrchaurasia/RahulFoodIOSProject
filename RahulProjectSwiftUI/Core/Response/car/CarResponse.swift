//
//  CarResponse.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 08/10/25.
//

import Foundation


struct CarResponse:  Codable  {
    let Message, Status: String
    let StatusNo: Int
    let MasterData: CarMasterData

    
}

// MARK: - MasterData
struct CarMasterData: Codable {
    let count: Int
    let proposals: [Proposal]
}
