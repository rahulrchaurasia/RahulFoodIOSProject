//
//  ProfileView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 15/11/24.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var authVM : AuthViewModel  // Common ViewModel
    
    //@EnvironmentObject var router : AppStateRouter
    
    @StateObject private var viewModel = ProfileImageVM()
    
    @Environment(\.presentationMode) var presentationMode
    
    let myProfile : UserProfile
    
   // let name : String
    
    var body: some View {
        
        VStack(spacing:0){
            
            // Add custom header at the top
            CustomNavigationBar(title: "Profile", showBackButton: true) {
                
              //  router.navigateBack()
            }
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
                                
                                Text(myProfile.name)
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.appblack )
                                
                                Text(myProfile.designation ?? "No Designation")
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
     
        .navigationTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
      
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

#Preview
{
    let profile = UserProfile(name: "Umesh", age: 32, gender: .male)
    ProfileView(myProfile: profile)
        .environmentObject(AuthViewModel(userRepository: DependencyContainer().userRepository))
    
}


