//
//  FloatingTextField.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 13/11/25.
//


import SwiftUI


struct FloatingTextField: View {
    let leftIcon: String?
    let rightIcon: String?
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    
    @FocusState private var isFocused: Bool
    @State private var showPassword: Bool = false
    @State private var placeholderOffset: EdgeInsets = EdgeInsets(top: 0, leading: 45, bottom: 0, trailing: 0)
    
    // Configuration
    var containerColor: Color = Color(.systemBackground)
    var activeBorderColor: Color = .blue
    var inactiveBorderColor: Color = .gray.opacity(0.6)
    var textColor: Color = .primary
    var iconColor: Color = .gray
    var placeholderColor: Color = .gray
    var cornerRadius: CGFloat = 4
    
    private var shouldFloat: Bool {
        isFocused || !text.isEmpty
    }
    
    private var currentBorderColor: Color {
        isFocused ? activeBorderColor : inactiveBorderColor
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            // Text Field Container
            HStack(spacing: 12) {
                if let leftIcon = leftIcon {
                    Image(systemName: leftIcon)
                        .foregroundColor(iconColor)
                        .frame(width: 20)
                }
                
                Group {
                    if isSecure && !showPassword {
                        SecureField("", text: $text)
                    } else {
                        TextField("", text: $text) { editing in
                            withAnimation(.spring(response: 0.2, dampingFraction: 0.8)) {
                                updatePlaceholderPosition(editing: editing)
                            }
                        }
                    }
                }
                .focused($isFocused)
                .foregroundColor(textColor)
                .font(.system(size: 16, weight: .regular))
                .onChange(of: isFocused) { newValue in
                    withAnimation(.spring(response: 0.2, dampingFraction: 0.8)) {
                        updatePlaceholderPosition(editing: newValue)
                    }
                }
                .onChange(of: text) { newValue in
                    withAnimation(.spring(response: 0.2, dampingFraction: 0.8)) {
                        updatePlaceholderPosition(editing: !newValue.isEmpty)
                    }
                }
                
                if isSecure {
                    Button(action: { showPassword.toggle() }) {
                        Image(systemName: showPassword ? "eye.slash" : "eye")
                            .foregroundColor(iconColor)
                    }
                } else if let rightIcon = rightIcon {
                    Image(systemName: rightIcon)
                        .foregroundColor(iconColor)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(currentBorderColor, lineWidth: 1)
                    .background(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(containerColor)
                    )
            )
            .frame(height: 56)
            
            // Floating Placeholder with background to cover border
            Text(placeholder)
                .font(.system(size: shouldFloat ? 12 : 16, weight: .medium))
                .foregroundColor(isFocused ? activeBorderColor : placeholderColor)
                .padding(.horizontal, 4)
                .background(containerColor) // This covers the border line
                .padding(placeholderOffset)
                .scaleEffect(shouldFloat ? 0.75 : 1.0, anchor: .leading)
                .onTapGesture {
                    isFocused = true
                }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            isFocused = true
        }
        .onAppear {
            // Initialize placeholder position based on initial text
            updatePlaceholderPosition(editing: !text.isEmpty)
        }
    }
    
    private func updatePlaceholderPosition(editing: Bool) {
        if editing || !text.isEmpty {
            placeholderOffset = EdgeInsets(top: -28, leading: leftIcon != nil ? 44 : 16, bottom: 0, trailing: 0)
        } else {
            placeholderOffset = EdgeInsets(top: 0, leading: leftIcon != nil ? 45 : 16, bottom: 0, trailing: 0)
        }
    }
}

// MARK: - Convenience Initializers
extension FloatingTextField {
    init(
        placeholder: String,
        text: Binding<String>,
        isSecure: Bool = false
    ) {
        self.leftIcon = nil
        self.rightIcon = nil
        self.placeholder = placeholder
        self._text = text
        self.isSecure = isSecure
    }
    
    init(
        leftIcon: String,
        placeholder: String,
        text: Binding<String>,
        isSecure: Bool = false
    ) {
        self.leftIcon = leftIcon
        self.rightIcon = nil
        self.placeholder = placeholder
        self._text = text
        self.isSecure = isSecure
    }
    
    init(
        leftIcon: String? = nil,
        rightIcon: String? = nil,
        placeholder: String,
        text: Binding<String>,
        isSecure: Bool = false
    ) {
        self.leftIcon = leftIcon
        self.rightIcon = rightIcon
        self.placeholder = placeholder
        self._text = text
        self.isSecure = isSecure
    }
}

// MARK: - View Modifier for Custom Styling (ADD THIS)
extension FloatingTextField {
    func customStyle(
        containerColor: Color? = nil,
        activeBorderColor: Color? = nil,
        inactiveBorderColor: Color? = nil,
        textColor: Color? = nil,
        iconColor: Color? = nil,
        placeholderColor: Color? = nil,
        cornerRadius: CGFloat? = nil
    ) -> some View {
        var view = self
        if let containerColor = containerColor { view.containerColor = containerColor }
        if let activeBorderColor = activeBorderColor { view.activeBorderColor = activeBorderColor }
        if let inactiveBorderColor = inactiveBorderColor { view.inactiveBorderColor = inactiveBorderColor }
        if let textColor = textColor { view.textColor = textColor }
        if let iconColor = iconColor { view.iconColor = iconColor }
        if let placeholderColor = placeholderColor { view.placeholderColor = placeholderColor }
        if let cornerRadius = cornerRadius { view.cornerRadius = cornerRadius }
        return view
    }
}


struct FloatingTextFieldDemo: View {
    @State private var emailAddress: String = ""
    @State private var password: String = ""
    @State private var fullName: String = ""
    @State private var phoneNumber: String = ""
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [Color.blue.opacity(0.05), Color.purple.opacity(0.05)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    Text("Material Design Text Fields")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .padding(.top, 20)
                    
                    // Glass container
                    VStack(spacing: 25) {
                        // Default style
                        FloatingTextField(
                            leftIcon: "person",
                            placeholder: "Default Style",
                            text: .constant("")
                        )
                        
                        // Custom background
                        FloatingTextField(
                            leftIcon: "envelope",
                            placeholder: "Custom Background",
                            text: .constant("")
                        )
                        .customStyle(containerColor: .blue.opacity(0.1))
                        
                        // Different colors
                        FloatingTextField(
                            leftIcon: "lock",
                            placeholder: "Purple Theme",
                            text: .constant("")
                        )
                        .customStyle(
                            activeBorderColor: .purple,
                            inactiveBorderColor: .purple.opacity(0.5),
                            iconColor: .purple,
                            placeholderColor: .purple
                        )
                        
                        // Rounded style
                        FloatingTextField(
                            placeholder: "Rounded Style",
                            text: .constant("")
                        )
                        .customStyle(cornerRadius: 12)
                    }
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.ultraThinMaterial)
                            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                    )
                    .padding(.horizontal, 24)
                    
                    // Interactive demo section
                    VStack(spacing: 25) {
                        Text("Interactive Demo")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        FloatingTextField(
                            leftIcon: "envelope",
                            placeholder: "Email Address",
                            text: $emailAddress
                        )
                        
                        FloatingTextField(
                            leftIcon: "lock",
                            placeholder: "Password",
                            text: $password,
                            isSecure: true
                        )
                    }
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.ultraThinMaterial)
                    )
                    .padding(.horizontal, 24)
                    
                    // Demo buttons
                    VStack(spacing: 12) {
                        Button("Fill Demo Data") {
                            withAnimation(.spring()) {
                                emailAddress = "john.doe@example.com"
                                password = "password123"
                                fullName = "John Doe"
                                phoneNumber = "+1 (555) 123-4567"
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Button("Clear All") {
                            withAnimation(.spring()) {
                                emailAddress = ""
                                password = ""
                                fullName = ""
                                phoneNumber = ""
                            }
                        }
                        .buttonStyle(.bordered)
                        .tint(.red)
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview("Fixed Floating TextField") {
    FloatingTextFieldDemo()
}

#Preview("Style Variations") {
    VStack(spacing: 25) {
        Text("Style Variations")
            .font(.title2)
            .bold()
            .padding(.top)
        
        VStack(spacing: 20) {
            FloatingTextField(
                leftIcon: "person",
                placeholder: "Default Style",
                text: .constant("")
            )
            
            FloatingTextField(
                leftIcon: "envelope",
                placeholder: "Custom Background",
                text: .constant("")
            )
            .customStyle(containerColor: .blue.opacity(0.1))
            
            FloatingTextField(
                leftIcon: "lock",
                placeholder: "Purple Theme",
                text: .constant("")
            )
            .customStyle(
                activeBorderColor: .purple,
                inactiveBorderColor: .purple.opacity(0.5),
                iconColor: .purple
            )
            
            FloatingTextField(
                placeholder: "Rounded Style",
                text: .constant("")
            )
            .customStyle(cornerRadius: 12)
        }
        .padding(.horizontal, 24)
        
        Spacer()
    }
    .padding()
}
