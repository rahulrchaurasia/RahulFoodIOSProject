//
//  MaskedRoundTextField.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 24/11/25.
//


import SwiftUI

struct MaskedRoundTextField: View {
    @Binding var text: String
    @FocusState private var isFocused: Bool
    
    var placeholder: String
    var maskPattern: String
    var keyboardType: UIKeyboardType = .numberPad
    var isError: Bool = false
    
    let cornerRadius: CGFloat = 12
    let backgroundColor = Color(.systemGray6)
    let errorColor = Color.red
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(
                            isError ? errorColor :
                            isFocused ? .blue :
                            .gray.opacity(0.3),
                            lineWidth: 1
                        )
                )

            MaskedUITextField(
                text: $text,
                placeholder: placeholder,
                maskPattern: maskPattern,
                keyboardType: keyboardType,
                isSecure: false,
                textColor: UIColor.black,
                font: .systemFont(ofSize: 16)
            )
            .padding(.horizontal, 16)
            .focused($isFocused)
        }
        .frame(height: 50)   // 👈 FIXED HERE — BEST PRACTICE
    }
}



struct ExampleDOBView: View {
    @State private var dob = ""
    @State private var isError = false

    var body: some View {
        VStack(spacing: 30) {

            MaskedRoundTextField(
                text: $dob,
                placeholder: "DD/MM/YYYY",
                maskPattern: "##/##/####",
                keyboardType: .numberPad,
                isError: isError
            )

            Text("DOB: \(dob)")
                .font(.headline)
        }
        .padding()
    }
}
#Preview {
    ExampleDOBView()
}
