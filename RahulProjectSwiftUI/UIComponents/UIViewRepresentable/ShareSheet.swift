//
//  ShareSheet.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 30/09/25.
//

import SwiftUI
import UIKit

struct ShareSheet: UIViewControllerRepresentable {
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil
       
    
    func makeUIViewController(context: Context) -> UIViewController {
        
        let controller = UIActivityViewController(
                    activityItems: activityItems,
                    applicationActivities: applicationActivities
                )
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
    
}
