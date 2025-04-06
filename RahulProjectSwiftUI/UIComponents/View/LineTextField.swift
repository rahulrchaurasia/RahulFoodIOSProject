//
//  LineTextField.swift
//  SwiftUIDemo
//
//  Created by Rahul Chaurasia on 28/05/24.
//

import SwiftUI

//Mark : Handling Error Message and Error stroke
import SwiftUI

struct LineTextField: View {
    // MARK: - Properties
    var title: String? = nil // Optional title
    var placeholder: String = "Placeholder"
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    
    var isError: Bool = false
    var errorMessage: String?
    var isSecureField: Bool = false
    
    // Optional font and color customizations
    var titleFont: Font = .system(size: 14, weight: .regular)
    var titleColor: Color = .gray
    var placeholderColor: Color = .placeholder
    var dividerColor: Color = .gray.opacity(0.4)
    var errorColor: Color = .red.opacity(0.7)
    var errorFont: Font = .caption
    
    @State private var isSecure: Bool = true // State to toggle secure field visibility

    // MARK: - Body
    var body: some View {
        VStack(spacing: 4) {
            // Title (if provided)
            if let title = title {
                Text(title)
                    .font(titleFont)
                    .foregroundColor(titleColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            // Input Field
            HStack {
                Group {
                    if isSecureField && isSecure {
                        SecureField(placeholder, text: $text)
                    } else {
                        TextField(placeholder, text: $text)
                    }
                }
                .keyboardType(keyboardType)
                .autocapitalization(.none)
                .autocorrectionDisabled()
                .submitLabel(.next)
                .frame(height: 30)
                .foregroundColor(placeholderColor)
                
                // Toggle visibility button for secure field
                if isSecureField {
                    Button(action: { isSecure.toggle() }) {
                        Image(systemName: isSecure ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.gray)
                            .accessibilityLabel(isSecure ? "Show password" : "Hide password")
                    }
                }
            }
            
            // Divider
            Divider()
                .frame(height: isError ? 1.5 : 1)
                .background(isError ? errorColor : dividerColor)
            
            // Error Message
            if isError, let errorMessage = errorMessage {
                Text(errorMessage)
                    .font(errorFont)
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 6)
                    .padding(.top, 3)
            }
        }
        .padding(.vertical, 6)
    }
}

// MARK: - Preview
#Preview {
    Group {
        LineTextField(
            title: "Password", // Optional title
            placeholder: "Enter your password",
            text: .constant(""),
            keyboardType: .default,
            isError: true,
            errorMessage: "Password is required",
            isSecureField: true
        )
        .previewDisplayName("Secure Field with Error")

        LineTextField(
            title: "Username", // Optional title
            placeholder: "Enter your username",
            text: .constant(""),
            keyboardType: .emailAddress,
            isError: false,
            isSecureField: false
        )
        .previewDisplayName("TextField without Error")
    }
}
