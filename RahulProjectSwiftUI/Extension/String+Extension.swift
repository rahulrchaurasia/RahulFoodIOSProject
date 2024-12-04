//
//  String+Extension.swift
//  SwiftUIDemo
//
//  Created by Rahul Chaurasia on 28/07/23.
//

import Foundation
/*
 let requiredFormat = currDate.toDateString(inputDateFormat: "yyyy-MM-dd", ouputDateFormat:
     "dd-MM-yyyy")

     self.endobTf.text! = requiredFormat
     self.strPosp_DOB  = currDate

     print("POSP Date Display",requiredFormat)
     
      self.endobTf.text? = currDate
 */

//offsetBy: index: Moves the index forward by the specified index value

extension String
{
    
    
    
    func toDateString(inputDateFormat inputFormat: String, outputDateFormat outputFormat: String) -> String? {
            let dateFormatter = DateFormatter()
            
            // Set the input date format
            dateFormatter.dateFormat = inputFormat
            guard let date = dateFormatter.date(from: self) else {
                // If the date conversion fails, return nil
                return nil
            }
            
            // Set the output date format
            dateFormatter.dateFormat = outputFormat
            return dateFormatter.string(from: date)
        }
    
    func toDateString1( inputDateFormat inputFormat  : String,  ouputDateFormat outputFormat  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputFormat
        let date = dateFormatter.date(from: self)
        dateFormatter.dateFormat = outputFormat
        return dateFormatter.string(from: date!)
        
        
    }
    
    //without removing spaces between words
    var removeSpecialCharacters: String {
        return self.components(separatedBy: CharacterSet.alphanumerics.inverted).filter({ !$0.isEmpty }).joined(separator: " ")
    }
    
    
    var removeSpecialCharactersWithoutSpace: String {
        return self.components(separatedBy: CharacterSet.alphanumerics.inverted).filter({ !$0.isEmpty }).joined()
    }
    
    var digitOnly: String { filter { ("0"..."9").contains($0) } }
    
    var isValidPhoneNumber: Bool {
        // Refine phone number validation using a robust regular expression or library
        let pattern = "^\\d{10}$" // Check for 10-digit Indian phone number format
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        return predicate.evaluate(with: self)
    }

    var maskedPhoneNumber: String {
        // Improve masking to handle different lengths and country codes
        let firstPart = String(self.prefix(6))
        let maskedPart = String(repeating: "*", count: 4)
        let lastPart = String(self.suffix(4))
        return "\(firstPart)\(maskedPart)\(lastPart)"
    }
    
    /* **********************************
    // let myString = "Hello, world!"
    // let characterAt5 = myString.stringAt(index: 5)  // characterAt5 will be "o"
     ***********************************  */
    func stringAt(index : Int) -> String
    {
        let stringIndex = self.index(self.startIndex,offsetBy: index)
        return String(self[stringIndex])
    }
    
    var isBackspace : Bool {
        
        let char = self.cString(using: String.Encoding.utf8)!
        return strcmp(char, "\\b") == -92 
    }
    
}
