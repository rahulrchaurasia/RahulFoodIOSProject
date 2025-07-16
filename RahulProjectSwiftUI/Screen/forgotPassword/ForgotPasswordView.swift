//
//  ForgotPasswordView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 22/11/24.
//

//Mark : Used of navigationDestination on base isPresenting Binding, so it will move to that page when binding value is updated..

//After that we use custom router for navigation Stack
import SwiftUI

struct ForgotPasswordView: View {
    
    @State private var email: String = ""
   // @State private var isEmailSent: Bool = false
    
    @EnvironmentObject var router : AppStateRouter
    @EnvironmentObject var loginRouter: LoginFlowRouter // 👈 new mini router only
    var body: some View {
        VStack(alignment:.leading, spacing:10) {
            Group {
                Text("Reset Password")
                    .font(.largeTitle)
                
                Text("Enter the email associated with your account and we will send u an emailwith instruction to reset your password.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

            }.padding(.bottom,32)
            
            
                      
            InputView(placeholder: "Enter your Email",  text: $email)
                .padding(.bottom,16)
            
            Button {
               // isEmailSent = true // Mark set for navigationDestination
                
                loginRouter.navigate(to: .emailSent)
            } label: {
               
                Text("Send Instruction")
            }
            .buttonStyle(CapsuleButtonStyle())

            
            Spacer()
        }
        .ignoresSafeArea()
        .padding()
        .padding(.horizontal)
        .toolbarRole(.editor)
//        .navigationDestination(isPresented: $isEmailSent) {
//            EmailSentView()
//        }
        
    }
}

#Preview {
    ForgotPasswordView()
}
