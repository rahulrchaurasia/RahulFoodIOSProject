//
//  PermissionHandler.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 05/12/25.
//


import SwiftUI
import AVFoundation
import Photos
import UIKit

@MainActor
final class PermissionHandler: ObservableObject {
    
    @Published private(set) var cameraStatus: AVAuthorizationStatus = .notDetermined
    @Published private(set) var photoStatus: PHAuthorizationStatus = .notDetermined
    
    private var lifecycleObserver: NSObjectProtocol?
    
    init() {
        refreshStatuses()
        setupLifecycleObserver()
    }
    
    deinit {
        if let observer = lifecycleObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    // MARK: - Current Status
    func refreshStatuses() {
        cameraStatus = AVCaptureDevice.authorizationStatus(for: .video)
        photoStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
    }
    
    // MARK: - Camera Permission
    func requestCameraPermission() async {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            cameraStatus = .authorized
            
        case .notDetermined:
            let granted = await AVCaptureDevice.requestAccess(for: .video)
            cameraStatus = granted ? .authorized : .denied
            
        case .denied:
            cameraStatus = .denied
            
        case .restricted:
            cameraStatus = .restricted
            
        @unknown default:
            cameraStatus = .notDetermined
        }
    }
    
    // MARK: - Photo Library Permission
    func requestPhotoLibraryPermission() async {
        switch PHPhotoLibrary.authorizationStatus(for: .readWrite) {
        case .authorized, .limited:
            photoStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
            
        case .notDetermined:
            let newStatus = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
            photoStatus = newStatus
            
        case .denied:
            photoStatus = .denied
            
        case .restricted:
            photoStatus = .restricted
            
        @unknown default:
            photoStatus = .notDetermined
        }
    }
    
    // MARK: - Settings
    func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(url)
        else { return }
        
        UIApplication.shared.open(url)
    }
    
    // MARK: - App Lifecycle
    private func setupLifecycleObserver() {
        lifecycleObserver = NotificationCenter.default.addObserver(
            forName: UIApplication.willEnterForegroundNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self else { return }
            Task { @MainActor in
                self.refreshStatuses()
            }
        }
    }
}

// Simple helper to make the enum printable
extension AVAuthorizationStatus {
    var description: String {
        switch self {
        case .authorized: return "Allowed"
        case .denied: return "Denied"
        case .notDetermined: return "Request"
        case .restricted: return "Restricted"
        @unknown default: return "Unknown"
        }
    }
}

extension PHAuthorizationStatus {
    var description: String {
        switch self {
        case .authorized: return "Allowed"
        case .limited: return "Limited"
        case .denied: return "Denied"
        case .notDetermined: return "Request"
        case .restricted: return "Restricted"
        @unknown default: return "Unknown"
        }
    }
}
