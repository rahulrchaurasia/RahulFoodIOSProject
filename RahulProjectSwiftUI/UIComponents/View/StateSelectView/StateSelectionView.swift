//
//  StateSelectionView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 17/11/25.
//

import SwiftUI

struct StateSelectionView: View {
    
    @Binding var selectedState : String?
    
    let states : [String]
    var errorColor : Color = .red
    var errorMessage: String?
    
    var isLoading: Bool   // 👈 Add loader flag here
    
    
    @State private var showingSheet = false
    
    
    var body: some View {
       
        
        VStack (alignment: .leading, spacing: 4) {
            
            Text("State *")
                .font(.subheadline)
                .foregroundStyle(.gray)
                .padding(.leading,16)
            
            
            Button {
                showingSheet = true
            } label: {
                HStack{
                   
                   if(isLoading){
                     
                       ProgressView()
                           .frame(maxWidth: .infinity, maxHeight: .infinity)
                         
                   }else{
                       
                       Text(selectedState ?? "Select State")
                           .foregroundStyle(selectedState == nil ? .gray : .primary)
                   }
                  
                   
                   Spacer()
                   
                   Image(systemName: "chevron.right")
                   
                   
               }
                .padding(.horizontal,16)
                .frame(height: 50)
                .background(
                    
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.systemGray6)
                        .overlay(content: {
                            
                            
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    errorMessage != nil ? errorColor : .gray.opacity(0.3),
                                    lineWidth: 1
                                )
                            
                        })
                        
                )
            }

            .disabled(isLoading)
            
           
            
            // Error Message
            
            if let msg = errorMessage, !msg.isEmpty {
                
                HStack (spacing : 4){
                    
                    Image(systemName: "exclamationmark.circle.fill")
                    Text(msg)
                    
                }
                .font(.caption)
                .foregroundStyle(errorColor)
                .padding(.horizontal,4)
                .padding(.top , 4)
            }
            
        }
        
       
        .sheet(isPresented: $showingSheet) {
            
            StateListView(selectedState: $selectedState, states: states)
        }

    }
}

#Preview {
    
    @State var selectedState: String? = nil
        let sampleStates = ["Maharashtra", "Karnataka", "Delhi", "Tamil Nadu", "Gujarat"]
    
    StateSelectionView(
            selectedState: $selectedState,
            states: sampleStates, errorMessage: "StateReq", isLoading: true
        )
        .padding()
}
