//
//  RoundMaskedTextField.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 24/11/25.
//

import SwiftUI


struct RoundMaskedTextField: View {
    @Binding var text: String
    
    let placeholder: String
    let maskPattern: String
    let keyboardType: UIKeyboardType
    @Binding var errorMessage: String
    @Binding var isError: Bool

    var backgroundColor: Color = Color(.systemGray6)
    var errorColor: Color = .red
    var cornerRadius: CGFloat = 12

    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            
            ZStack {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(backgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(
                                isError ? errorColor :
                                isFocused ? .blue : .gray.opacity(0.3),
                                lineWidth: 1
                            )
                    )

                HStack {
                    // Masked TextField (Left)
                    MaskedUITextField(
                        text: $text,
                        placeholder: placeholder,
                        maskPattern: maskPattern,
                        keyboardType: keyboardType,
                        isSecure: false,
                        textColor: UIColor.appBlackcolor,
                        font: .systemFont(ofSize: 16)
                    )
                    .frame(height: 50)
                    .focused($isFocused)

                    // Calendar icon (Right)
                    Image(systemName: "calendar")
                        .foregroundColor(.gray)
                        .padding(.trailing, 12)
                }
                .padding(.leading, 16)
            }
            .frame(height: 50)
            

            // Error label
            if isError && !errorMessage.isEmpty {
                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.circle")
                        .foregroundColor(errorColor)
                    Text(errorMessage)
                        .font(.system(size: 12))
                        .foregroundColor(errorColor)
                    Spacer()
                }
                .padding(.horizontal, 4)
                .transition(.opacity)
            }
        }
        .animation(.easeInOut, value: isError || isFocused)
    }
}




#Preview {
    DemoMaskedField()
}


struct DemoMaskedField: View {
    @State private var dob = ""
    @State private var error = ""
    @State private var isError = false
    
    var body: some View {
        VStack(spacing: 20) {
            RoundMaskedTextField(
                text: $dob,
                placeholder: "DD/MM/YYYY",
                maskPattern: "##/##/####",
                keyboardType: .numberPad,
                errorMessage: $error,
                isError: $isError
            )
            .frame(width: .infinity,height: 50)
            .padding()
            
            Button("Validate DOB") {
                if dob.count < 10 {
                    error = "Please enter a valid date"
                    isError = true
                } else {
                    error = ""
                    isError = false
                }
            }
        }
    }
}
