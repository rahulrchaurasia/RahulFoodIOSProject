//
//  NotificationScreen.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 27/02/26.
//

import SwiftUI

struct NotificationScreen: View {
    @StateObject private var viewModel = NotificationViewModel()
    
    var body: some View {
       
        VStack(spacing:20){
            
            CustomButton(title: "Schedule 5s Notification") {
                
                viewModel.scheduleTestNotification()
            }
            
            CustomButton(title: "Schedule Daily 9AM") {
                viewModel.scheduleDailyReminder()
            }
            
            CustomButton(title: "Cancel All Notifications") {
                
                viewModel.cancelAllNotifications()
            }
        }
    }
}

#Preview {
    NotificationScreen()
}
