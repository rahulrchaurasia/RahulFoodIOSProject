//
//  ProfileView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 13/11/24.
//



import SwiftUI
import PhotosUI

// MARK: - ProfileView
struct ProfileView1: View {
    @StateObject private var viewModel = ProfileImageViewModel1()
    
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
                   
                   Button(action: { viewModel.showMediaPicker = true }) {
                       ZStack {
                           Circle()
                               .fill(Color.blue)
                               .frame(width: 40, height: 40)
                           
                           Image(systemName: "pencil")
                               .foregroundColor(.white)
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
           .sheet(isPresented: $viewModel.showMediaPicker) {
               ImagePickerBottomSheet1(
                   isPresented: $viewModel.showMediaPicker,
                   permissionManager: viewModel.permissionManager,
                   showPermissionAlert: $viewModel.showPermissionAlert,
                   viewModel: viewModel
               )
               .presentationDetents([.height(280)])
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
       }
}


//#Preview {
//    ProfileView()
//}
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView1()
    }
}
