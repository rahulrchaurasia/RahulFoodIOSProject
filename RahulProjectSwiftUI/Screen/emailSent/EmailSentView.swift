//
//  EmailSentView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 22/11/24.
//

import SwiftUI

struct EmailSentView: View {
    
    @State var email: String = ""
    @EnvironmentObject var router : Router
    var body: some View {
        
        VStack(spacing: 24) {
            
            Spacer()
            
            Image(systemName: "envelope.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundStyle(Color.teal)
            
            
            VStack {
                
//                InputView(placeholder: "Enter Email", text: $email)
                Text("Check Your Email")
                    .font(.largeTitle.bold())
                Text("We have sent you a confirmation email. Please check your inbox.")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Button {
                    
                    router.navigateToRoot()
                    
                } label: {
                    
                    Text("Skip, I will confirm later")
                       
                        
                }.buttonStyle(CapsuleButtonStyle())
                
               
                
            }
            
            Spacer()
            
            //footer
            
            Button {
                
                router.navigateBack()
                
            } label: {
                
               (
                    Text("Did you receive the email check your spam folder or ")
                        .foregroundColor(.gray)
                    +
                    Text("Try another email address")
                        .foregroundColor(.teal)
                )

               
            }


        }
        .ignoresSafeArea()
        .padding()
        .padding(.horizontal)
        .offset(y :-20)
        .toolbarRole(.editor)
    }
}

#Preview {
    EmailSentView()
}
