//
//  createAccountView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 18/11/24.
//

import SwiftUI

struct createAccountView: View {
    
    @State var email: String = ""
    @State var fullName: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""
    
    @EnvironmentObject var authVM : AuthViewModel
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        
        VStack {
            Text("Create Account")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Please complete all information to create an account")
                .font(.headline)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .padding(.vertical)
            
            
            InputView(placeholder: "Email or Phone Number", text: $email)
            
            InputView(placeholder: "Full Name", text: $fullName)
            
            InputView(placeholder: "Password", text: $password)
            
            
            ZStack(alignment: .trailing) {
                InputView(placeholder: " Confirm Password", text: $confirmPassword)
              
                if(!password.isEmpty && !confirmPassword.isEmpty){
                    
                    Image(systemName:
                            isvalidPassword ? "checkmark.circle.fill" :"xmark.circle.fill"
                    )
                        .imageScale(.large)
                        .foregroundStyle(isvalidPassword ?
                                         Color.systemGreen : Color.systemRed)
                    
                }
               
                
            }
          
            
            Spacer()
            
            Button {
                
                presentationMode.wrappedValue.dismiss()
                
            } label: {
                
                Text("Create Account")
            }
            .buttonStyle(CapsuleButtonStyle())

            
            
        }
        .ignoresSafeArea()
        .navigationTitle("Set up your account")
        .toolbarRole(.editor)   //MARK : remove back button title
        .padding()
       
    }
    
    
    var isvalidPassword: Bool {
        password == confirmPassword
    }
}

#Preview {
    createAccountView()
        .environmentObject(AuthViewModel())
}
