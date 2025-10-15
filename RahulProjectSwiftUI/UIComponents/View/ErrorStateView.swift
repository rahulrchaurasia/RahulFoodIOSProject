//
//  ErrorStateView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 09/10/25.
//


import SwiftUI


struct ErrorStateView: View {
    let error: NetworkError
    let retryAction: (() -> Void)?
    
    init(_ error: NetworkError, retryAction: (() -> Void)? = nil) {
        self.error = error
        self.retryAction = retryAction
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "wifi.exclamationmark")
                .font(.system(size: 50))
                .foregroundColor(.red)
                .padding(.bottom, 8)
            
            Text("Something Went Wrong")
                .font(.headline)
            
            Text(error.localizedDescription)
                .font(.caption)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            if let retryAction = retryAction {
                Button(action: retryAction) {
                    Label("Try Again", systemImage: "arrow.clockwise")
                        .font(.callout)
                }
                .buttonStyle(.borderedProminent)
                .padding(.top, 8)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor.systemGray6))
    }
}


#Preview {
    Group {
        let networkError  = NetworkError.invalidRequest
        ErrorStateView(networkError){
            
            print(networkError.localizedDescription)
        }
       

       
    }
}
