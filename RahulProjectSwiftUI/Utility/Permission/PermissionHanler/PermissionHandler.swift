//
//  PermissionHandler.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 05/12/25.
//

import SwiftUI
import Photos
import AVFoundation



//@MainActor
//final class PermissionHandler: ObservableObject {
//
//    @Published private(set) var cameraStatus: AVAuthorizationStatus = .notDetermined
//    @Published private(set) var photoStatus: PHAuthorizationStatus = .notDetermined
//
//    init() {
//        refreshStatuses()
//    }
//
//    func refreshStatuses() {
//        cameraStatus = AVCaptureDevice.authorizationStatus(for: .video)
//        photoStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
//    }
//
//    // MARK: - Request Camera
//    func requestCameraPermission() async {
//        let granted = await AVCaptureDevice.requestAccess(for: .video)
//        refreshStatuses()
//        print("Camera granted:", granted)
//    }
//
//    // MARK: - Request Photos
//    func requestPhotoLibraryPermission() async {
//        let status = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
//        await MainActor.run { self.photoStatus = status }
//        print("Photos granted:", status == .authorized || status == .limited)
//    }
//
//    // Helper wrappers to call from UI
//    func handleCameraTap(onGranted: @escaping () -> Void) {
//        switch cameraStatus {
//        case .authorized:
//            onGranted()
//        case .notDetermined:
//            Task {
//                await requestCameraPermission()
//                if cameraStatus == .authorized { onGranted() }
//            }
//        case .denied, .restricted:
//            openSettings()
//        @unknown default:
//            break
//        }
//    }
//
//    func handlePhotoTap(onGranted: @escaping () -> Void) {
//        switch photoStatus {
//        case .authorized, .limited:
//            onGranted()
//        case .notDetermined:
//            Task {
//                await requestPhotoLibraryPermission()
//                if photoStatus == .authorized || photoStatus == .limited { onGranted() }
//            }
//        case .denied, .restricted:
//            openSettings()
//        @unknown default:
//            break
//        }
//    }
//
//    // MARK: - Settings
//    func openSettings() {
//        guard let url = URL(string: UIApplication.openSettingsURLString),
//              UIApplication.shared.canOpenURL(url)
//        else { return }
//        UIApplication.shared.open(url)
//    }
//}




import Foundation
import AVFoundation
import Photos
import UIKit

@MainActor

final class PermissionHandler: ObservableObject {

    @Published private(set) var cameraStatus: AVAuthorizationStatus = .notDetermined
    @Published private(set) var photoStatus: PHAuthorizationStatus = .notDetermined

    init() { refresh() }

    func refresh() {
        cameraStatus = AVCaptureDevice.authorizationStatus(for: .video)
        photoStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
    }

    // MARK: - CAMERA
    func requestCamera() async -> Bool {
        let granted = await AVCaptureDevice.requestAccess(for: .video)
        refresh()
        return granted
    }

    // MARK: - PHOTOS
    func requestPhotos() async -> Bool {
        let status = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
        photoStatus = status
        return status == .authorized || status == .limited
    }

    // MARK: - Helpers
    var isCameraAuthorized: Bool {
        cameraStatus == .authorized
    }

    var isPhotoAuthorized: Bool {
        photoStatus == .authorized || photoStatus == .limited
    }
}

