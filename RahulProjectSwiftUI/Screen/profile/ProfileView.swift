//
//  ProfileView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 06/12/25.
//

import SwiftUI




import SwiftUI

struct ProfileView: View {

    @StateObject var vm: ProfileViewModel
    @EnvironmentObject var coordinator: AppCoordinator
    
    //Initialized @StateObject using Dependency Container
    init(profileVM: ProfileViewModel) {
        _vm = StateObject(wrappedValue: profileVM)
    }
    
    var body: some View {
        
        
        ZStack {
            // Background color
            Color(.systemGray6)
                .ignoresSafeArea(.all)
            VStack(spacing:0) {
                
                CustomToolbar(
                    title: "Profile",
                    backAction: {coordinator.navigateBack()
                    }
                )
                
                // Avatar Section
                ZStack {
                    Circle().fill(Color.gray.opacity(0.2))
                        .frame(width: 150, height: 150)
                    
                    if let img = vm.profileImage {
                        Image(uiImage: img)
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
                    
                    Button {
                        vm.openPicker()
                    } label: {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 40, height: 40)
                            .overlay(Image(systemName: "pencil").foregroundColor(.white))
                    }
                    .offset(x: 50, y: 50)
                }
                .padding(40)
                
                Spacer()
                
                Spacer()
                
                List{
                    
                    Section{
                        
                        HStack{
                            
                            Text("RC")
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                                .frame(width: 70, height: 70)
                                .background(Color(.lightGray))
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 4){
                                
                                Text("myProfile.name")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.appblack )
                                
                                Text("myProfile.designation" ?? "No Designation")
                                    .font(.footnote)
                                    .foregroundStyle(Color.statusBar)
                                
                            }
                        }
                    }
                    
                    
                    Section("Account") {
                        
                        Button {
                            
                        } label: {
                            
                            Label {
                                
                                Text("Sign Out")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.appblack)
                            } icon: {
                                
                                Image(systemName: "arrow.left.circle.fill")
                                    .foregroundStyle(.red)
                            }
                            
                        }
                        
                        Button {
                            
                        } label: {
                            
                            Label {
                                
                                Text("Delete Account")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.appblack)
                            } icon: {
                                
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.red)
                            }
                            
                        }
                        
                    }
                    
                }
                
                .scrollContentBackground(.hidden) // Disable default background
                .background(.blue.opacity(0.1)) // Light red background
                
                
            }
        }

        .sheet(item: $vm.activeSheet) { sheet in
            switch sheet {

            case .permission:
                PermissionBottomSheet(
                    handler: vm.permissions,
                    cameraAction: { vm.requestCameraAndOpen() },
                    galleryAction: { vm.requestPhotosAndOpen() }
                )

            case .camera:
                CameraView(image: Binding(
                    get: { vm.profileImage },
                    set: { vm.didPick($0) }
                ))

            case .gallery:
                GalleryView(image: Binding(
                    get: { vm.profileImage },
                    set: { vm.didPick($0) }
                ))
            }
        }

        .alert("Permission Required",
               isPresented: $vm.showDeniedAlert) {

            Button("Cancel", role: .cancel) {}

            Button("Settings") {
                vm.openSettings()
            }

        } message: {
            Text("Please enable \(vm.deniedType == .camera ? "Camera" : "Gallery") access in Settings.")
        }
    }
}


#Preview {
    ProfileView(profileVM: DependencyContainer().makeProfileViewModel())
}
