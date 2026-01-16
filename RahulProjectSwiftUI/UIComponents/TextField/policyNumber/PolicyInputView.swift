//
//  PolicyInputView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 20/12/25.
//

import SwiftUI

struct PolicyInputView: View {
    
    @Binding var value: String
    @State private var error = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            
            PolicyTextField(
                text: $value,
                placeholder: "Policy Number (POH1002)"
            )
            .frame(height: 50)
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(error.isEmpty ? .gray : .red)
            )
            .onChange(of: value) { newValue in
                validate(newValue)
            }
            
            if !error.isEmpty {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
        
        
    }
    
    private func validate(_ value: String) {
            if value.count == 7 && !PolicyValidator.isValid(value) {
                error = "Format must be POH1002"
            } else {
                error = ""
            }
        }
    
    
}

#Preview {
    @State  var policy = "POH1002"
    
    PolicyInputView(
            value: .constant("POH1002")
            
        )
        .padding()
}
