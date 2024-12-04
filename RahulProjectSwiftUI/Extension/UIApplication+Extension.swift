//
//  UIApplication+Extension.swift
//  SwiftUIDemo
//
//  Created by Rahul Chaurasia on 20/07/23.
//

import Foundation
import UIKit

extension UIApplication: UIGestureRecognizerDelegate {
    
    func addTapGestureRecognizer1() {
            guard let window = windows.first else { return }
            let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
            tapGesture.cancelsTouchesInView = false
            tapGesture.delegate = self
            tapGesture.name = "MyTapGesture"
            window.addGestureRecognizer(tapGesture)
        }
    
     func addTapGestureRecognizer() {
          guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let window = windowScene.windows.first else {
              return
          }

          let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
          tapGesture.cancelsTouchesInView = false
          tapGesture.delegate = self
          tapGesture.name = "MyTapGesture"
          window.addGestureRecognizer(tapGesture)
      }
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false // set to `false` if you don't want to detect tap during other gestures
    }
}
