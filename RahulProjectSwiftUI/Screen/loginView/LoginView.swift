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
    var body: some View {
       
        ScrollView{
            
            VStack{
                
                //logo
                Image("a2")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 180)
                   
                
                //title
                title
                              
                Spacer().frame(height: 20)
                
                //textField
                
                InputView(placeholder: "Email or Phone Number", text: $email)
               
                InputView(placeholder: "Password",
                          isSecureField : true,
                          text: $password)
                
                Spacer().frame(height: 20)
                //forgot Button
                
                HStack {
                    Spacer()
                    Button {
                        
                    }
                    label: {
                        Text("Forgot Password")
                            .foregroundStyle(.gray)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            
                    }
                }
                Spacer().frame(height: 20)
               
                //Login Button
                
                Button {
                    
                }
                label: {
                    Text("Login")
                        
                }
                .buttonStyle(CapsuleButtonStyle())
                
                
                //bottom View
                
                HStack(spacing: 16) {
                    line
                    Text("or")
                    line
                }
                .foregroundStyle(.gray)
                
                Button {
                    
                }
                label: {
            
                    Label("Sign up with Apple", systemImage: "apple.logo")
                        
                }
                .buttonStyle(CapsuleButtonStyle(bgColor: .black))
                
            }
        }
        .ignoresSafeArea()
        .padding(.vertical,10)
        .padding()
    }
    
    
    private var title : some View{
        
        Text("Lets Connect with Us!")
            .font(.title2)
            .fontWeight(.semibold)

    }
    
    private var line : some View{
        
        VStack{
            Divider()
                .frame(height: 1)
        }

    }
}

#Preview {
    LoginView()
}

struct CapsuleButtonStyle : ButtonStyle {
    
    var bgColor : Color = .teal
    var textColor : Color = .white
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(textColor )
            .padding()
            .frame(maxWidth: .infinity)
            .background(Capsule().fill(bgColor ))
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}
