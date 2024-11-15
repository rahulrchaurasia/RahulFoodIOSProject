//
//  ProfileImageViewModel.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 13/11/24.
//

import Foundation
import UIKit
import _PhotosUI_SwiftUI


// MARK: - Profile Image View Model
//Note : handle Photo UI here
//_PhotosUI_SwiftUI : cropping option not present in ver 16/17
class ProfileImageViewModel1: ObservableObject {
    @Published var profileImage: UIImage?
        @Published var showMediaPicker = false
        @Published var showCamera = false
        @Published var showPermissionAlert = false
        @Published var photoSelection: PhotosPickerItem? {
            didSet {
                handlePhotoSelection()
            }
        }
        
        let permissionManager: MediaPermissionManager
        
        init(permissionManager: MediaPermissionManager = MediaPermissionManager()) {
            self.permissionManager = permissionManager
            checkPermissions()
        }
    
    func checkPermissions() {
            permissionManager.checkCameraPermission()
            permissionManager.checkPhotoLibraryPermission()
        }
        
        func processSelectedImage(_ image: UIImage) {
            profileImage = image
        }
        
        
    private func handlePhotoSelection() {
            guard let item = photoSelection else { return }
            
            switch permissionManager.photoLibraryStatus {
            case .authorized, .limited:
                loadImage(from: item)
            case .denied, .restricted:
                showPermissionAlert = true
                showMediaPicker = false
            case .notDetermined:
                Task {
                    if await permissionManager.requestPhotoLibraryPermission() {
                        loadImage(from: item)
                    } else {
                        await MainActor.run {
                            showPermissionAlert = true
                            showMediaPicker = false
                        }
                    }
                }
            }
        }
    
    
    private func loadImage(from item: PhotosPickerItem) {
         Task {
             if let data = try? await item.loadTransferable(type: Data.self),
                let image = UIImage(data: data) {
                 await MainActor.run {
                     processSelectedImage(image)
                     showMediaPicker = false
                 }
             }
         }
     }
}
