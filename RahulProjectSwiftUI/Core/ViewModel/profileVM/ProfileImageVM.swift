//
//  ProfileImageViewModel.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 15/11/24.
//

import Foundation
import UIKit


// Modified ViewModel
class ProfileImageVM: ObservableObject {
    
    @Published var profileImage: UIImage?
    
    //Mark :Open the BottomSheet Dialog ie {ImagePickerBottomSheet}  using showMediaPicker
    @Published var showMediaPicker = false
    
    //Mark : For Camera and Gallery
    @Published var showCamera = false
    @Published var showGallery = false
    
    //Mark : For Permission Alert
    @Published var showPermissionAlert = false
    
    let permissionManager: MediaPermissionManager
    
    init(permissionManager: MediaPermissionManager = MediaPermissionManager()) {
        self.permissionManager = permissionManager
        checkPermissions()
    }
    
    func checkPermissions() {
        permissionManager.checkCameraPermission()
        permissionManager.checkPhotoLibraryPermission()
    }
    
//    func processSelectedImage(_ image: UIImage) {
//        profileImage = image
//    }
}
