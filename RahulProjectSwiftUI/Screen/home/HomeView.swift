//
//  HomeView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 22/11/24.
//

import SwiftUI

// Mark : navigationDestination demo
struct HomeView: View {
 
    //@State private var navigationState: NavigationState?
    
    @State private var navigationPath = NavigationPath() // For managing navigation stack

    var body: some View {
        
        
        NavigationStack(path: $navigationPath ){
            
            VStack(alignment:.leading, spacing:15) {
                
                
                Spacer()
                
                Button {
                    navigationPath.append(NavigationState.emailSent)
                } label: {
                    Text("Send Email Instruction")
                }
                .buttonStyle(CapsuleButtonStyle())
                
                Button {
                    navigationPath.append(NavigationState.whatsSent)
                } label: {
                    Text("Send WhatsApp Instruction")
                }
                .buttonStyle(CapsuleButtonStyle(bgColor: Color.orange.opacity(0.7), textColor: Color.red, hasBorder: true))
                
                
                Button {
                    
                    navigationPath.append(NavigationState.smsSent)
                } label: {
                    Text("Send Sms Instruction")
                }.buttonStyle(CapsuleButtonStyle(bgColor: Color.black, textColor: Color.white, hasBorder: true))
                
                
            }
            
            .ignoresSafeArea()
            .padding()
            .padding(.horizontal)
            .toolbarRole(.editor)
            
            .navigationDestination(for: NavigationState.self) { state in
             
                    switch state {
                    case .emailSent:
                        
                        EmailSentView()
                        
                    case .whatsSent:
                        
                        WhatsAppView(onClose: {
                            navigationPath.removeLast()
                            
                        })
                    case .smsSent:
                        SMSSentView {
                            navigationPath.removeLast()
                        }
                    case .childPage:
                        SMSSentView{
                            
                            navigationPath.removeLast()
                        }
                    }
                
            }
        }

      
        
    
    
    

    }
}

#Preview {
    HomeView()
}

struct SMSSentView: View {
    
    var onClose: () -> Void // Callback for when the view is closed
       
       var body: some View {
           VStack {
               Text("SMS Sent")
                   .font(.largeTitle)
                   .foregroundColor(.blue)
               
               Button("Close") {
                   onClose() // Trigger the callback to remove the item
               }
               .padding()
               .buttonStyle(.borderedProminent)
           }
       }
    
}

struct WhatsAppView: View {
    
    var onClose: () -> Void // Callback for when the view is closed
       
       var body: some View {
           VStack {
               Text("Whats App Sent")
                   .font(.largeTitle)
                   .foregroundColor(.blue)
               
               Button("Close") {
                   onClose() // Trigger the callback to remove the item
               }
               .padding()
               .buttonStyle(.borderedProminent)
           }
       }
}

