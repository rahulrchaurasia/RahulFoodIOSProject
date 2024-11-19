//
//  ImagePickerBottomSheet.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 13/11/24.
//

import SwiftUI
import _PhotosUI_SwiftUI

//_PhotosUI_SwiftUI : cropping option not present in ver 16/17
struct ImagePickerBottomSheet1: View {
    @Binding var isPresented: Bool
    @ObservedObject var permissionManager: MediaPermissionManager
    @Binding var showPermissionAlert: Bool
    @ObservedObject var viewModel: ProfileImageViewModel1
    
    // Move photoSelection to ViewModel
    
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
            
            PhotosPicker(selection: $viewModel.photoSelection,
                        matching: .images,
                        photoLibrary: .shared()) {
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
}




#Preview {
    
    let permissionManager = MediaPermissionManager()
    let viewModel = ProfileImageViewModel1()
    ImagePickerBottomSheet1(isPresented: .constant(true), permissionManager: permissionManager ,showPermissionAlert: .constant(true), viewModel: viewModel)
}
