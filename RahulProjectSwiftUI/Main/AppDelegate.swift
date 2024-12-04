//
//  AppDelegate.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 21/11/24.
//

import Foundation
import UIKit
import FirebaseCore

class AppDelegate : NSObject, UIApplicationDelegate {
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure() 
        return true
    }
    
  }
