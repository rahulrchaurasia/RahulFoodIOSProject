//
//  OnboardingButtonView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 30/12/24.
//

import SwiftUI

struct OnboardingButtonView: View {
    
    let onSkip: () -> ()
    let onNext: () -> ()
    
    let buttonTitle: String
    let isLastItem: Bool
    
    var body: some View {
       
        HStack {
            if !isLastItem {
                Button(action: onSkip) {
                    Text("Skip")
                        .font(.headline)
                        .foregroundStyle(Color.skyblue)
                        .padding()
                        .padding(.horizontal, 20)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            
            Spacer()
            
            Button {
                onNext()
            } label: {
               
                Text(buttonTitle)
                    .font(.customfont(.semibold, fontSize: 20))
                    .foregroundStyle(.white)
                    .padding(.vertical, 16)
                    .padding(.horizontal, 60)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.appgreen)
                                        
                     )
            }

        }
    }
}

#Preview {
    OnboardingButtonView( onSkip :{
        
    }, onNext: {
        
    }, buttonTitle: "Start", isLastItem: false)
}
