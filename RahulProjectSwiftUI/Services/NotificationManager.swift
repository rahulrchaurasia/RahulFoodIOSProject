//
//  NotificationManager.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 27/02/26.
//

import Foundation


import Foundation
import UserNotifications
import UIKit


final class NotificationManager : NSObject {
    
    
    // MARK: - Singleton
       static let shared = NotificationManager()
    
    
    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
        
    }
    
    func requestPermission() async throws -> Bool {
         try await UNUserNotificationCenter.current()
             .requestAuthorization(options: [.alert, .badge, .sound])
     }
    
    func getNotificationSettings() async -> UNNotificationSettings {
            await UNUserNotificationCenter.current().notificationSettings()
        }
        
    // MARK: - Schedule Time Interval Notification
     
      func scheduleTimeIntervalNotification(
          id: String = UUID().uuidString,
          title: String,
          body: String,
          seconds: TimeInterval,
          repeats: Bool = false
      ) async throws {
          
          let content = UNMutableNotificationContent()
          content.title = title
          content.body = body
          content.sound = .default
          content.badge = NSNumber(value: 1)
          
          let trigger = UNTimeIntervalNotificationTrigger(
              timeInterval: seconds,
              repeats: repeats
          )
          
          let request = UNNotificationRequest(
              identifier: id,
              content: content,
              trigger: trigger
          )
          
          try await UNUserNotificationCenter.current().add(request)
      }
    
    // MARK: - Schedule Calendar Notification
    
    func scheduleDailyNotification(
           id: String = UUID().uuidString,
           title: String,
           body: String,
           hour: Int,
           minute: Int
       ) async throws {
           
           let content = UNMutableNotificationContent()
           content.title = title
           content.body = body
           content.sound = .default
           
           var components = DateComponents()
           components.hour = hour
           components.minute = minute
           
           let trigger = UNCalendarNotificationTrigger(
               dateMatching: components,
               repeats: true
           )
           
           let request = UNNotificationRequest(
               identifier: id,
               content: content,
               trigger: trigger
           )
           
           try await UNUserNotificationCenter.current().add(request)
       }
    
    // MARK: - Cancel
       
       func cancelNotification(id: String) {
           UNUserNotificationCenter.current()
               .removePendingNotificationRequests(withIdentifiers: [id])
       }
    
    func cancelAll() {
           UNUserNotificationCenter.current()
               .removeAllPendingNotificationRequests()
       }
}


// MARK: - UNUserNotificationCenterDelegate

extension NotificationManager: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler:
        @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // Show banner even when app is open
        completionHandler([.banner, .sound, .badge])
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        print("User tapped notification: \(response.notification.request.identifier)")
        completionHandler()
    }
}
