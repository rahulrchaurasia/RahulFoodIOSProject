//
//  PushNotificationManager.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 24/02/26.
//


import Foundation
import FirebaseMessaging
import UserNotifications

final class PushNotificationManager {
    
    static let shared = PushNotificationManager()
    private init() {}
    
    
    // MARK: - Token Handling
    
    func handleTokenRefresh(_ token : String){
        
        print("🔥 New FCM Token Received: \(token)")
        
        // 1. Save to your UserDefaultsManager
        UserDefaultsManager.shared.fcmToken = token
        
        // 2. Only send to backend if the user is actually logged in!
        if UserDefaultsManager.shared.isLoggedIn {
            sendTokenToBackend(token)
        }
    }
    
    // Call this manually right after your Login API succeeds
        func syncTokenAfterLogin() {
            Messaging.messaging().token { token, error in
                if let token = token {
                    self.handleTokenRefresh(token)
                } else {
                    print("❌ Error fetching FCM token manually: \(error?.localizedDescription ?? "")")
                }
            }
        }
    
    
    private func sendTokenToBackend(_ token: String) {
            // TODO: Call your actual Network/Repository API here
            // Example: container.userRepository.updateDeviceToken(token)
            print("🌐 Sending FCM Token to Backend for User: \(UserDefaultsManager.shared.loggedInUserName)")
        }
        
        // MARK: - Notification Tap Handling
        func handleNotificationTap(userInfo: [AnyHashable: Any]) {
            print("👆 Notification Tapped with payload: \(userInfo)")
            
            // TODO: Talk to your `AppCoordinator` to navigate based on the payload.
            // E.g., NotificationCenter.default.post(...) OR direct Coordinator call
        }
}
