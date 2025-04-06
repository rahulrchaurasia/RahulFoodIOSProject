//
//  UserProfile.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 30/11/24.
//

import Foundation

struct UserProfile :Hashable, Codable {
    let name: String
    let age: Int
    let gender: Gender
    var designation : String? = nil
}

enum Gender  : String ,Hashable, Codable{
    
    case male = "Male"
    case female = "Female"
}


//let profile = UserProfile(name: "Rahul", age: 32, gender: .male)
