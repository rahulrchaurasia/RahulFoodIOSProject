//
//  Constant.swift
//  SwiftUIDemo
//
//  Created by Rahul Chaurasia on 29/03/23.
//

import Foundation



let serverError  = "Server time out.Please try again"
let serverUnavailbleError  = "Server are not available.Please try again"

struct Constant {
    
    static let noDataMSG = "No Data Found"
    static let minStringReqMSG = "Items Required atleat 3 character 😢😯🤐"
}

struct UserDefaultKEY {
    
    
    static let ItemKey = "ItemKey"
}


class Configuration: NSObject {

    
    static let token = "1234567890"
    
   
    static let appVersion =  Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    
    static let buildVersion =  Bundle.main.infoDictionary?["CFBundleVersion"] as! String
}
