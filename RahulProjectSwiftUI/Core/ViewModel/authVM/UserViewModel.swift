//
//  UserViewModel.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 03/04/25.
//

import Foundation


import SwiftUI
import Combine

import SwiftUI
import Combine

@MainActor
final class UserViewModel: ObservableObject {
    // MARK: - Form Fields
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var address: String = ""
    
    // MARK: - UI State
    @Published var focusedField: LoginField?
    @Published var fieldErrors: [LoginField: String] = [:]
    @Published var alertState = AlertState.hidden
    
    // MARK: - Network State
    @Published var loginState: ViewState<User> = .idle
    @Published var isLoginSuccessful: Bool = false // ← ADDED THIS PROPERTY
    
    // MARK: - User Session
    @AppStorage("userEmail") private var storedEmail: String = ""
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    
    // MARK: - Dependencies
    private let userRepository: UserRepositoryProtocol
   
    // MARK: - Initializer
    init(userRepository: UserRepositoryProtocol = UserRepository.shared) {
        self.userRepository = userRepository
        
        // Load saved state if needed
        self.email = storedEmail
    }
    
    // MARK: - Login Actions
    func login() async {
        // Reset login success flag
        isLoginSuccessful = false // ← ADDED THIS LINE
        
        // Validate form first
        let validationResult = validateForm()
        
        // If validation fails, exit early
        guard validationResult.isValid else {
            return
        }
        
        // Update network state
        loginState = .loading
        
        do {
            // Fetch user from repository
            let users = try await userRepository.getUserByEmail(email)
            
            // Process login success
            if !users.isEmpty {
                let user = users[0] // Assuming the first user is what we need
                
                // Save to UserDefaults
                UserDefaultsManager.shared.saveLoggedInUser(user)
                
                // Update session state
                saveUserSession(email: email)
                
                // Update UI state
                loginState = .success(user)
                isLoginSuccessful = true // ← ADDED THIS LINE
                clearForm()
            } else {
                // No user found
                loginState = .error(.noData)
                alertState = .error(message: "User not found")
            }
        } catch {
            // Handle errors
            handleLoginError(error)
        }
    }
    
    func validateForm() -> ValidationResult<LoginField> {
        // Use the static method of LoginFormValidator
        let result = LoginFormValidator.validate(
            email: email,
            password: password,
            address: address
        )
        
        // Update UI state based on validation
        self.fieldErrors = result.errors
        self.focusedField = result.firstErrorField
        
        if !result.isValid, let firstField = result.firstErrorField {
            self.alertState = .error(message: result.errors[firstField] ?? "Validation failed")
        }
        
        return result
    }
    
    // MARK: - Error Handling
    private func handleLoginError(_ error: Error) {
        if let networkError = error as? NetworkError {
            loginState = .error(networkError)
            alertState = .error(message: networkError.errorDescription ?? "Unknown error")
        } else {
            loginState = .error(.networkError(error))
            alertState = .error(message: "Unexpected error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Session Management
    private func saveUserSession(email: String) {
        storedEmail = email
        isLoggedIn = true
        UserDefaultsManager.shared.isLoggedIn = true
    }
    
    func logout() {
        UserDefaultsManager.shared.logoutUser()
        clearForm()
        isLoggedIn = false
        storedEmail = ""
        isLoginSuccessful = false // ← ADDED THIS LINE
    }
    
    private func clearForm() {
        email = ""
        password = ""
        address = ""
        fieldErrors = [:]
        focusedField = nil
    }
    
    // MARK: - Field Error Helpers
    func hasError(for field: LoginField) -> Bool {
        return fieldErrors[field] != nil
    }
    
    func errorMessage(for field: LoginField) -> String? {
        return fieldErrors[field]
    }
    
    // MARK: - Convenience Properties
    var isLoading: Bool {
        if case .loading = loginState {
            return true
        }
        return false
    }
    
    var showError: Bool {
        get { alertState.isPresented }
        set {
            if !newValue {
                alertState = .hidden
            }
        }
    }
    
    var errorMessage: String {
        alertState.message
    }
}
