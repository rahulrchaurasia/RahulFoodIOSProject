//
//  ImagePickerBottomSheet.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 15/11/24.
//

import SwiftUI

// Modified ImagePickerBottomSheet without extra sheet
struct ImagePickerBottomSheet: View {
    @Binding var isPresented: Bool
    
    //ImagePickerBottomSheet uses @ObservedObject to observe the same instance of MediaPermissionManager that was passed from ProfileImageVM.
    @ObservedObject var permissionManager: MediaPermissionManager
    @Binding var showPermissionAlert: Bool
    @ObservedObject var viewModel: ProfileImageVM
    
    var body: some View {
        VStack(spacing: 20) {
            Capsule()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 40, height: 4)
                .padding(.top, 8)
            
            Text("Select Image Source")
                .font(.headline)
                .padding(.top, 8)
            
            Button(action: {
                handleCameraSelection()
            }) {
                HStack {
                    Image(systemName: "camera.fill")
                        .font(.title2)
                    Text("Take Photo")
                        .font(.body)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            
            Button(action: {
                handleGallerySelection()
            }) {
                HStack {
                    Image(systemName: "photo.fill")
                        .font(.title2)
                    Text("Choose from Gallery")
                        .font(.body)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            
            Button(action: { isPresented = false }) {
                Text("Cancel")
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(20)
    }
    
    private func handleCameraSelection() {
        switch permissionManager.cameraStatus {
        case .authorized:
            viewModel.showCamera = true
            isPresented = false
        case .denied, .restricted:
            showPermissionAlert = true
            isPresented = false
        case .notDetermined:
            Task {
                if await permissionManager.requestCameraPermission() {
                    await MainActor.run {
                        viewModel.showCamera = true
                        isPresented = false
                    }
                } else {
                    await MainActor.run {
                        showPermissionAlert = true
                        isPresented = false
                    }
                }
            }
        default:
            break
        }
    }
    
    private func handleGallerySelection() {
        switch permissionManager.photoLibraryStatus {
        case .authorized, .limited:
            viewModel.showGallery = true
            isPresented = false
        case .denied, .restricted:
            showPermissionAlert = true
            isPresented = false
        case .notDetermined:
            Task {
                
           // Note: If the permission is granted, the code inside the if block will execute.
                if await permissionManager.requestPhotoLibraryPermission() {
                    await MainActor.run {
                        viewModel.showGallery = true
                        isPresented = false
                    }
                } else {
                    await MainActor.run {
                        showPermissionAlert = true
                        isPresented = false
                    }
                }
            }
        }
    }
}

#Preview {
    
    let permissionManager = MediaPermissionManager()
    let viewModel = ProfileImageVM()
    ImagePickerBottomSheet(isPresented: .constant(true), permissionManager: permissionManager ,showPermissionAlert: .constant(true), viewModel: viewModel)
}


