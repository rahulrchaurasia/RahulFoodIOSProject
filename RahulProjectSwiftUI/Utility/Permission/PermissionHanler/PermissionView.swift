//
//  PermissionView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 05/12/25.
//

import SwiftUI
import Photos
struct PermissionView: View {
    
    @StateObject private var permissions = PermissionHandler()
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("Permissions")
                .font(.largeTitle)
            
            // Camera Permission Button
            permissionButton(
                label: "Camera: \(permissions.cameraStatus.description)",
                systemImage: "camera",
                status: permissions.cameraStatus,
                requestAction: { await permissions.requestCameraPermission() }
            )
            
            // Photo Library Permission Button
            permissionButton(
                label: "Photos: \(permissions.photoStatus.description)",
                systemImage: "photo",
                status: permissions.photoStatus,
                requestAction: { await permissions.requestPhotoLibraryPermission() }
            )
        }
        .padding()
    }
    
    // MARK: - Reusable Permission Button
    @ViewBuilder
    private func permissionButton(
        label: String,
        systemImage: String,
        status: PHAuthorizationStatus,
        requestAction: @escaping () async -> Void
    ) -> some View {
        Button {
            handleAction(for: status, requestAction: requestAction)
        } label: {
            Label(label, systemImage: systemImage)
        }
        .buttonStyle(.bordered)
    }
    
    private func permissionButton(
        label: String,
        systemImage: String,
        status: AVAuthorizationStatus,
        requestAction: @escaping () async -> Void
    ) -> some View {
        Button {
            handleAction(for: status, requestAction: requestAction)
        } label: {
            Label(label, systemImage: systemImage)
        }
        .buttonStyle(.bordered)
    }
    
    // MARK: - Action Handler
    private func handleAction(
        for status: AVAuthorizationStatus,
        requestAction: @escaping () async -> Void
    ) {
        switch status {
        case .notDetermined:
            Task { await requestAction() }
        case .denied, .restricted:
            permissions.openSettings()
        default:
            break
        }
    }
    
    private func handleAction(
        for status: PHAuthorizationStatus,
        requestAction: @escaping () async -> Void
    ) {
        switch status {
        case .notDetermined:
            Task { await requestAction() }
        case .denied, .restricted:
            permissions.openSettings()
        default:
            break
        }
    }
}

#Preview {
    PermissionView()
}
