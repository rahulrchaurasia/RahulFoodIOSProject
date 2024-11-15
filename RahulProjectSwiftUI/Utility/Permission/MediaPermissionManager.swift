//
//  MediaPermissionManager.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 13/11/24.
//

import Foundation
import SwiftUI
import PhotosUI
import AVFoundation
import Photos



enum MediaSource {
    case camera
    case photoLibrary
}

enum PermissionStatus {
    case notDetermined, authorized, denied, restricted, limited
}

class MediaPermissionManager: ObservableObject {
    @Published private(set) var cameraStatus: PermissionStatus = .notDetermined
    @Published private(set) var photoLibraryStatus: PermissionStatus = .notDetermined

    func checkCameraPermission() {
        DispatchQueue.main.async {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                self.cameraStatus = .authorized
            case .notDetermined:
                self.cameraStatus = .notDetermined
            case .denied:
                self.cameraStatus = .denied
            case .restricted:
                self.cameraStatus = .restricted
            @unknown default:
                self.cameraStatus = .denied
            }
        }
    }

    func requestCameraPermission() async -> Bool {
        let granted = await AVCaptureDevice.requestAccess(for: .video)
        DispatchQueue.main.async {
            self.cameraStatus = granted ? .authorized : .denied
        }
        return granted
    }

    func checkPhotoLibraryPermission() {
        DispatchQueue.main.async {
            let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
            switch status {
            case .authorized:
                self.photoLibraryStatus = .authorized
            case .notDetermined:
                self.photoLibraryStatus = .notDetermined
            case .denied:
                self.photoLibraryStatus = .denied
            case .restricted:
                self.photoLibraryStatus = .restricted
            case .limited:
                self.photoLibraryStatus = .limited
            @unknown default:
                self.photoLibraryStatus = .denied
            }
        }
    }

    func requestPhotoLibraryPermission() async -> Bool {
        let status = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
        DispatchQueue.main.async {
            self.photoLibraryStatus = status == .authorized || status == .limited ? .authorized : .denied
        }
        return status == .authorized || status == .limited
    }

    func openSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl)
        }
    }
}
