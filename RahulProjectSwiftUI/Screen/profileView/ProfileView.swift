//
//  ProfileView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 15/11/24.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileImageVM()
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 150, height: 150)
                
                if let image = viewModel.profileImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .foregroundColor(.gray)
                }
                
            //Mark :Open the BottomSheet Dialog using showMediaPicker
                Button(action: { viewModel.showMediaPicker = true }) {
                    ZStack {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: "pencil")
                            .foregroundStyle(.white)
                    }
                }
                .offset(x: 50, y: 50)
            }
            .padding(.top, 50)
            
            Spacer()
        }
        
      
        .sheet(isPresented: $viewModel.showCamera) {
            CameraView(image: $viewModel.profileImage)
        }
        .sheet(isPresented: $viewModel.showGallery) {
            GalleryView(image: $viewModel.profileImage)
        }
        //Mark:-> In button we set showMediaPicker true hence its open
        .sheet(isPresented: $viewModel.showMediaPicker) {
            ImagePickerBottomSheet(
                isPresented: $viewModel.showMediaPicker,
                permissionManager: viewModel.permissionManager,
                showPermissionAlert: $viewModel.showPermissionAlert,
                viewModel: viewModel
            )
            .presentationDetents([.height(250)])
        }
        .alert("Permission Required",
               isPresented: $viewModel.showPermissionAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Settings") {
                viewModel.permissionManager.openSettings()
            }
        } message: {
            Text("Please enable required permissions in Settings to use this feature")
        }
        .onAppear {
            viewModel.checkPermissions()
        }
    }
}

#Preview {
    ProfileView()
}
