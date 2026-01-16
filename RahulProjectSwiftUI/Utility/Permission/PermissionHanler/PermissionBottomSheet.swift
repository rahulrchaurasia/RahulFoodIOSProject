//
//  PermissionBottomSheet.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 06/12/25.
//

import SwiftUI

import SwiftUI
import AVFoundation
import Photos


struct PermissionBottomSheet: View {

    @ObservedObject var handler: PermissionHandler
    let cameraAction: () -> Void
    let galleryAction: () -> Void

    var body: some View {
        VStack(spacing: 24) {

            Capsule()
                .fill(Color.secondary.opacity(0.3))
                .frame(width: 40, height: 4)
                .padding(.top, 12)

            Text("Choose Image Source")
                .font(.system(size: 20, weight: .semibold, design: .rounded))

            VStack(spacing: 16) {
                PermissionOptionButton(
                    icon: "camera.fill",
                    title: "Camera",
                    tint: .blue,
                    action: cameraAction
                )

                PermissionOptionButton(
                    icon: "photo.on.rectangle.fill",
                    title: "Gallery",
                    tint: .purple,
                    action: galleryAction
                )
            }

            Spacer()
        }
        .padding(.horizontal)
        .padding(.bottom, 20)
        .presentationDetents([.medium])
        
    }
}




#Preview {
    
    let handler = PermissionHandler()
    PermissionBottomSheet(handler: handler, cameraAction: {}, galleryAction: {})
}
