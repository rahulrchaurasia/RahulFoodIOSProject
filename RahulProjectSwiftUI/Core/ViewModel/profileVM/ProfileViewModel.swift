//
//  ProfileViewModel.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 06/12/25.
//

import Foundation
import UIKit


enum ActiveSheet: Identifiable {
    case permission
    case camera
    case gallery

    var id: Int { hashValue }
}



enum PermissionType { case camera, photos }


@MainActor
final class ProfileViewModel: ObservableObject {

    @Published var activeSheet: ActiveSheet?
    @Published var profileImage: UIImage?
    @Published var showDeniedAlert = false
    @Published var deniedType: PermissionType?

    let permissions: PermissionHandler

    init(permissionHandler: PermissionHandler) {
        self.permissions = permissionHandler
    }

    func openPicker() {
        activeSheet = .permission
    }

    func requestCameraAndOpen() {
        Task {
            if permissions.isCameraAuthorized {
                activeSheet = .camera
                return
            }

            let granted = await permissions.requestCamera()
            granted ? (activeSheet = .camera)
                    : deny(.camera)
        }
    }

    func requestPhotosAndOpen() {
        Task {
            if permissions.isPhotoAuthorized {
                activeSheet = .gallery
                return
            }

            let granted = await permissions.requestPhotos()
            granted ? (activeSheet = .gallery)
                    : deny(.photos)
        }
    }

    func didPick(_ image: UIImage?) {
        profileImage = image
        activeSheet = nil // dismiss
    }

    private func deny(_ type: PermissionType) {
        deniedType = type
        showDeniedAlert = true
    }

    func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}
