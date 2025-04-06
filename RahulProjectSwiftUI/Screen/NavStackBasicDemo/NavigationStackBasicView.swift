//
//  ShareView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 20/12/24.
//

/*
 Default Way to Use Navigation Stack
 Note :1> We have Used Custom  Navigation Stack
 2> In App We Must have Only One Navigation Stack which is at root.
 3> For Basic Demo of Navigation Stack we used here...
  default Navigation Stack with "navigationPath"
 
 navigationPath
 */
import SwiftUI

struct NavigationStackBasicView: View {
    @State private var navigationPath = NavigationPath() // For managing navigation stack

    var body: some View {
        
        
        NavigationStack(path: $navigationPath ){
            
            VStack(alignment:.leading, spacing:15) {
                
                
                Spacer()
                
                Button {
                    //Note: here we append the path
                    navigationPath.append(NavigationState.emailSent)
                } label: {
                    Text("Send Email Instruction")
                }
                .buttonStyle(CapsuleButtonStyle())
                
                Button {
                    // here we append the path
                    navigationPath.append(NavigationState.whatsSent)
                } label: {
                    Text("Send WhatsApp Instruction")
                }
                .buttonStyle(CapsuleButtonStyle(bgColor: Color.orange.opacity(0.7), textColor: Color.red, hasBorder: true))
                
                
                Button {
                    
                    // here we append the path
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
                        
                        DemoEmailSentView {
                            navigationPath.removeLast()
                        }
                        
                    case .whatsSent:
                        
                        DemoWhatsAppView(onClose: {
                            navigationPath.removeLast()
                            
                        })
                    case .smsSent:
                        DemoSMSSentView {
                            navigationPath.removeLast()
                        }
                    case .childPage:
                        DemoSMSSentView{
                            
                            navigationPath.removeLast()
                        }
                    }
                
            }
        }

      
        
    
    
    

    }
}

struct DemoEmailSentView: View {
    
    var onClose: () -> Void // Callback for when the view is closed
       
       var body: some View {
           VStack {
               Text("Email Sent")
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

struct DemoSMSSentView: View {
    
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

struct DemoWhatsAppView: View {
    
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
#Preview {
    NavigationStackBasicView()
}
