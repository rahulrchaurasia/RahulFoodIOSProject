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
    
    
    static let minStringReqMSG = "Items Required atleat 3 character 😢😯🤐"
}

struct UserDefaultKEY {
    
    
    static let ItemKey = "ItemKey"
}


class Configuration: NSObject {

  // static let baseURLString = "http://qa.mgfm.in"               //testing
    //http://api.magicfinmart.com
   static let baseURLString = "https://horizon.policyboss.com:5443/quote/Postfm/"     //live
    
    static let baseROOTURL = "https://horizon.policyboss.com:5443"
    
    static let baseFileUploadURLString = "https://horizon.policyboss.com:5443/quote/Postfm_fileupload/"
    //http://49.50.95.141:19
    //http://202.131.96.101:3333
    static let baseServiceURLString = ""     // for attendance  (Not in used)
    static let baseEncryptedErpIdURL = ""
  
    static let basegenerateloanLeadURL = ""   //ERP URL {Android}  for loan (currently used in pending case only)
    static let basehealthassureURL = ""
    
   
    static let appVersion =  Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    
    static let buildVersion =  Bundle.main.infoDictionary?["CFBundleVersion"] as! String
}
