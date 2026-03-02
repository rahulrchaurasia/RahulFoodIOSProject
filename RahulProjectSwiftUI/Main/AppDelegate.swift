//
//  AppDelegate.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 21/11/24.
//

import Foundation
import UIKit

import SwiftUI
import FirebaseCore
import FirebaseMessaging
import UserNotifications

class AppDelegate :NSObject, UIApplicationDelegate {
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        
        // 2. Set Delegates
                Messaging.messaging().delegate = self
                UNUserNotificationCenter.current().delegate = self
                
                // 3. Ask for Permission
                let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { _, _ in }
                
                // 4. Register with Apple
                application.registerForRemoteNotifications()
        return true
    }
    
    
    // MARK: - Handlers
        
        // Apple sends the Device Token -> We give it to Firebase
        func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
           // Messaging.messaging().apnsToken = deviceToken
            // 1. Log to verify Apple actually gave you a token
                let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
                print("✅ Registered for Notifications with token: \(tokenString)")
                
                // 2. Explicitly set the token type (helps Firebase in some environments)
                Messaging.messaging().apnsToken = deviceToken
                Messaging.messaging().setAPNSToken(deviceToken, type: .sandbox) // Change to .prod for App Store
            
        }
        
       
  }


// MARK: - MessagingDelegate
extension AppDelegate: MessagingDelegate {

    // Called whenever FCM token is created or refreshed
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("FCM Token: \(fcmToken ?? "nil")")

        // Save this token to your backend server
        // This is what you use to send push notifications to THIS specific device
        if let token = fcmToken {

            // Hand off to our clean manager
            PushNotificationManager.shared.handleTokenRefresh(token)

        }
    }
}


// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    
    // Handle tap on notification
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                    didReceive response: UNNotificationResponse,
                                    withCompletionHandler completionHandler: @escaping () -> Void) {
            
            let userInfo = response.notification.request.content.userInfo
            print("👆 User tapped notification: \(userInfo)")
            
            PushNotificationManager.shared.handleNotificationTap(userInfo: userInfo)
            
            completionHandler()
        }
    
    // Allow notifications to show up even if the app is open (Foreground)
    // Show notification when app is in FOREGROUND
        func userNotificationCenter(_ center: UNUserNotificationCenter,
                                    willPresent notification: UNNotification,
                                    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            
            print("🔔 Notification arrived while app is open!")
            // .banner is required for iOS 14+ to show UI at the top
            completionHandler([.banner, .sound, .badge])
        }
    
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print("📩 Background notification received")
        completionHandler(.newData)
    }
    
    // MARK: - Get FCM Token on demand
    func getCurrentFCMToken() {
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM token: \(error)")
            } else if let token = token {
                print("FCM Token: \(token)")
            }
        }
    }
}
