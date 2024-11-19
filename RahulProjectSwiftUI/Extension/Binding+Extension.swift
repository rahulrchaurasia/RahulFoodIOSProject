//
//  Binding+Extension.swift
//  SwiftUIDemo
//
//  Created by Rahul Chaurasia on 23/02/24.
//

import Foundation
import SwiftUI



extension Binding where Value == String {
    
    /* **********************************************************
    //  For Limit the TextField character size
     ************************************************************/
 
    // added :05otp
    func limit(_ length : Int) -> Self {
        
        if self.wrappedValue.count > length {
            
            DispatchQueue.main.async{
                self.wrappedValue = String(self.wrappedValue.prefix(length))
                
            }
        }
        return self
        
    }
    
}

