//
//  RoundTextField.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 13/11/25.
//

import SwiftUI

import SwiftUI

struct RoundTextField: View {
    @Binding var text: String
    let placeholder: String
    @Binding var errorMessage: String
    @Binding var isError: Bool
    var isSecure: Bool = false
    var backgroundColor: Color = Color(.systemGray6)
    var errorColor: Color = .red
    var cornerRadius: CGFloat = 12
    
    @FocusState private var isFocused: Bool
    
    // MARK: - Convenience Initializers
    
    init(
        text: Binding<String>,
        placeholder: String,
        isSecure: Bool = false
    ) {
        self._text = text
        self.placeholder = placeholder
        self.isSecure = isSecure
        self._errorMessage = .constant("")
        self._isError = .constant(false)
    }
    
    init(
        text: Binding<String>,
        placeholder: String,
        errorMessage: Binding<String>,
        isError: Binding<Bool>,
        isSecure: Bool = false
    ) {
        self._text = text
        self.placeholder = placeholder
        self._errorMessage = errorMessage
        self._isError = isError
        self.isSecure = isSecure
    }
    
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
                
                Group {
                    if isSecure {
                        SecureField("", text: $text)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                    } else {
                        TextField("", text: $text)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                    }
                }
                .tint(.appBlackColor)     // 👈 FIX CURSOR COLOR (Light/Dark mode)
                .placeholder(when: text.isEmpty) {
                    Text(placeholder)
                        .foregroundColor(.gray)
                }
                .focused($isFocused)
                .padding(.horizontal, 16)
            }
            .frame(height: 50)
            
            // Enhanced error message with smooth animations
            if isError && !errorMessage.isEmpty {
                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.system(size: 12))
                        .foregroundColor(errorColor)
                    
                    Text(errorMessage)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(errorColor)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Spacer()
                }
                .padding(.horizontal, 4)
                .transition(.asymmetric(
                    insertion: .opacity.combined(with: .move(edge: .top)),
                    removal: .opacity
                ))
            }
        }
        .animation(.easeInOut(duration: 0.3), value: isError || isFocused)
    }
}

// MARK: - Placeholder Extension (iOS 16+ compatible)
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
#Preview ("RoundTextField - Basic States"){
  
        VStack(spacing: 20) {
            // Normal State
            VStack(alignment: .leading) {
                Text("Normal State")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                RoundTextField(
                    text: .constant(""),
                    placeholder: "Enter your email"
                )
            }
            
            // With Text
            VStack(alignment: .leading) {
                Text("With Text")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                RoundTextField(
                    text: .constant("john.doe@example.com"),
                    placeholder: "Email"
                )
            }
            
            // Secure Field
            VStack(alignment: .leading) {
                Text("Secure Field")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                RoundTextField(
                    text: .constant(""),
                    placeholder: "Password",
                    isSecure: true
                )
            }
            
            Spacer()
        }
        .padding()
    
}

#Preview("RoundTextField - Error States") {
    VStack(spacing: 20) {
        // Error State
        VStack(alignment: .leading) {
            Text("Error State")
                .font(.headline)
                .foregroundColor(.secondary)
            
            RoundTextField(
                text: .constant("invalid-email"),
                placeholder: "Email",
                errorMessage: .constant("Please enter a valid email address"),
                isError: .constant(true)
            )
        }
        
        // Secure Field with Error
        VStack(alignment: .leading) {
            Text("Secure Field Error")
                .font(.headline)
                .foregroundColor(.secondary)
            
            RoundTextField(
                text: .constant("123"),
                placeholder: "Password",
                errorMessage: .constant("Password must be at least 6 characters"),
                isError: .constant(true),
                isSecure: true
            )
        }
        
        Spacer()
    }
    .padding()
}

#Preview("Advanced RoundTextField - Animations") {
    AnimationPreview()
}

struct AnimationPreview: View {
    @State private var email = ""
    @State private var emailError = ""
    @State private var emailErrorShow = false
    
    @State private var password = ""
    @State private var passwordError = ""
    @State private var passwordErrorShow = false
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Tap buttons to see smooth animations")
                .font(.caption)
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading) {
                RoundTextField(
                    text: $email,
                    placeholder: "Email address",
                    errorMessage: $emailError,
                    isError: $emailErrorShow
                )
                
                HStack {
                    Button("Show Error") {
                        emailError = "Invalid email format"
                        emailErrorShow = true
                    }
                    
                    Button("Hide Error") {
                        emailErrorShow = false
                    }
                }
                .buttonStyle(.bordered)
            }
            
            VStack(alignment: .leading) {
                RoundTextField(
                    text: $password,
                    placeholder: "Password",
                    errorMessage: $passwordError,
                    isError: $passwordErrorShow,
                    isSecure: true
                )
                
                HStack {
                    Button("Show Error") {
                        passwordError = "Password too short"
                        passwordErrorShow = true
                    }
                    
                    Button("Hide Error") {
                        passwordErrorShow = false
                    }
                }
                .buttonStyle(.bordered)
            }
            
            Button("Toggle Both") {
                withAnimation {
                    emailErrorShow.toggle()
                    passwordErrorShow.toggle()
                    
                    if emailErrorShow {
                        emailError = "Invalid email format"
                        passwordError = "Password too short"
                    } else {
                        emailError = ""
                        passwordError = ""
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            
            Spacer()
        }
        .padding()
    }
}
