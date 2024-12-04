//
//  LoginView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 17/11/24.
//

import SwiftUI

struct LoginView: View {
    
    @State var email: String = ""
    @State var password: String = ""
    @EnvironmentObject var authVM : AuthViewModel
    @EnvironmentObject var router : Router
    
    var body: some View {
       
       ScrollView{
           
           VStack(spacing: 16){
               
               //logo
               logo
               
               //title
               title
               
               Spacer().frame(height: 10)
               
               //textField
               
               description
               
               Spacer().frame(height: 10)
               //forgot Button
               
               forgotButton
               
               Spacer().frame(height: 10)
               
               //Login Button
               
               
               
               Button {
                   
                   demo()
               }
               label: {
                   Text("Login")
                   
               }
               .buttonStyle(CapsuleButtonStyle())
               
               
               //bottom View
               
               HStack(spacing: 16) {
                   DividerView()
                   Text("or")
                   DividerView()
               }
               .foregroundStyle(.gray)
               
               Button {
                   
                  
               }
               label: {
                   
                   Label("Sign up with Apple", systemImage: "apple.logo")
                   
               }
             .buttonStyle(CapsuleButtonStyle(bgColor: .black))
               
               Spacer().frame(height: 10)
               
               Button {
                   
                   let profile = UserProfile(name: "Rahul", age: 32, gender: .male, designation: "Android Developer")
                   router.navigate(to: .profile(userProfile: profile))
               } label: {
                   
                   HStack{
                       Image("check_list")
                           .resizable()
                           .frame(width: 15, height: 15)
                           .scaledToFit()
                       Text("Sign up with Google")
                   }
               }
               .buttonStyle(
                   CapsuleButtonStyle(
                       bgColor: .clear,
                       textColor: .black,
                       hasBorder: true
                   )
               )
               
             
               //footer View
               
               footerView

           }
       }
       .scrollIndicators(.hidden)
       .ignoresSafeArea()
       //.padding(.vertical,8)
       .padding()
    }
    
    
    
    
    private var logo : some View{
        
        Image("a2")
            .resizable()
            .scaledToFit()
            .frame(height: 120)
    }
    
    private var title : some View{
        
        Text("Lets Connect with Us!")
            .font(.title2)
            .fontWeight(.semibold)

    }
    
    private var description : some View{
        
        VStack(alignment: .leading){
            InputView(placeholder: "Email or Phone Number", text: $email)
            Spacer().frame(height: 10)
            InputView(placeholder: "Password",
                      isSecureField : true,
                      text: $password)
        }
    }
    
    private var forgotButton :some View {
        
        HStack {
            Spacer()
            
            Button {
                
                router.navigate(to: .forgotPassword)
            } label: {
                Text("Forgot Password")
                    .foregroundStyle(.gray)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }

            
//            NavigationLink {
//                ForgotPasswordView()
//                //HomeView()
//            } label: {
//                Text("Forgot Password")
//                    .foregroundStyle(.gray)
//                    .font(.subheadline)
//                    .fontWeight(.medium)
//            }

        
        }
    }
    
    private var footerView :some View{
        
        
        Button {
            router.navigate(to: .createAccount(name: "Data From Login"))
        } label: {
            HStack{
                
                Text("Donot have an account")
                    .foregroundStyle(.black)
                
                Text("Sign up")
                    .foregroundStyle(.teal)
            }
        }

        
    }
    
    
    private func demo(){
        
        var suitCase = SuitCase(color: "purple", weight: 90)
        
       
        suitCase.weight = 80
      
        print("Color: \(suitCase.color), Weight: \(suitCase.weight)")
    }
    
    
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}







