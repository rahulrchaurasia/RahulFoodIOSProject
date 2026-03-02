//
//  NotificationViewModel.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 27/02/26.
//

import Foundation



final class NotificationViewModel : ObservableObject {
    
    func scheduleTestNotification() {
            Task {
                try? await NotificationManager.shared
                    .scheduleTimeIntervalNotification(
                        title: "Hello 👋",
                        body: "Industrial local notification",
                        seconds: 5
                    )
            }
        }
    
    func scheduleDailyReminder() {
            Task {
                try? await NotificationManager.shared
                    .scheduleDailyNotification(
                        title: "Daily Reminder",
                        body: "Time to check the app!",
                        hour: 9,
                        minute: 0
                    )
            }
        }
    
    func cancelAllNotifications() {
            NotificationManager.shared.cancelAll()
        }
    
}
