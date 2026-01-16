//
//  PermissionRow.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 06/12/25.
//

import SwiftUI
import Photos

import AVFoundation


struct PermissionRow: View {
    let title: String
    let icon: String

    // typed status
    let permission: AppPermission

    // async action to request permission (kept for completeness, not used if using handler helpers)
    let requestAction: () async -> Void

    // open settings closure (sync)
    let openSettings: () -> Void

    // optional callback when permission is already granted (for example: open camera / open picker)
    let onGranted: () -> Void

    var body: some View {
        Button {
            handleTap()
        } label: {
            HStack {
                Label(title, systemImage: icon)
                Spacer()
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(.bordered)
    }

    private func handleTap() {
        switch permission {
        case .camera(let s):
            switch s {
            case .authorized:
                onGranted()
            case .notDetermined:
                // Call the async request closure safely
                Task { await requestAction() }
            case .denied, .restricted:
                openSettings()
            @unknown default:
                break
            }

        case .photos(let s):
            switch s {
            case .authorized, .limited:
                onGranted()
            case .notDetermined:
                Task { await requestAction() }
            case .denied, .restricted:
                openSettings()
            @unknown default:
                break
            }
        }
    }
}


#Preview {
    
    PermissionRow(
        title: "Camera Permission",
        icon: "camera",
        permission: .camera(.notDetermined),
        requestAction: {},                 // Dummy async closure
        openSettings: {},                  // Dummy closure
        onGranted: {}                      // Dummy closure
    )
    .padding(.horizontal)
    PermissionRow(
        title: "Photo Library",
        icon: "photo",
        permission: .photos(.denied),
        requestAction: {},
        openSettings: {},
        onGranted: {}
    )
    .padding(.horizontal)
    
    
}


//#Preview("Photos Preview") {
//   
//}
