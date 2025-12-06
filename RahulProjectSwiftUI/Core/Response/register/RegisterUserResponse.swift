//
//  RegisterUserResponse.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 12/11/25.
//

import Foundation

struct RegisterUserResponse : Decodable ,Equatable {
    
    
    let Message: String
        let Status: String
        let StatusNo: Int
        let MasterData: RegisterMasterData?
        
}

struct RegisterMasterData: Decodable,Equatable {
        let Result: String
        let Message: String
        let SavedStatus: Int
    }
