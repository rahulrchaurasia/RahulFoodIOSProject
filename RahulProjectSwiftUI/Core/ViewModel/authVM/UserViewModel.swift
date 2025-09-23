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
   // @Published var isLoginSuccessful: Bool = false // ← ADDED THIS PROPERTY
    
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
         // isLoginSuccessful = false // ← ADDED THIS LINE
        
        // Validate form first
        let validationResult = validateForm()
        
        // If validation fails, exit early
        guard validationResult.isValid else {
            
            // // The alertState is already set inside validateForm().
            return
        }
        
        // 3. Use a defer block for guaranteed state cleanup. THIS IS A KEY IMPROVEMENT.
            // This code will run an the end of the function, no matter how it exits (success, error, etc).
        defer {
                // If after everything, we are still in a loading state (which indicates an unexpected error),
                // reset to idle. This prevents the UI from being stuck in a loading spinner forever.
                if case .loading = loginState {
                    loginState = .idle
                }
          }
        // Update network state
        loginState = .loading
        
        do {
            // Fetch user from repository
            // 4. Add a print statement for definitive debugging
            print("🚀 [UserViewModel] Attempting to fetch user for email: \(email)")

            // Fetch user from repository
            let users = try await userRepository.getUserByEmail(email)
            
            print("✅ [UserViewModel] Successfully fetched repository response. User count: \(users.count)")

            // Process login success
            
            // Process login success
                   if let user = users.first {
                       // Save to UserDefaults
                       UserDefaultsManager.shared.saveLoggedInUser(user)
                       
                       // Update session state
                       saveUserSession(email: email)
                       
                       // Update UI state to success
                       loginState = .success(user)
                       clearForm()
                   } else {
                       // No user found - Treat this as a specific, known failure case
                       print("🤔 [UserViewModel] No user found for email: \(email)")
                       let error = NetworkError.noData
                       loginState = .error(error) // Set network state
                       alertState = .error(message: "The email or password you entered is incorrect.") // Set UI alert
                   }
            
        } catch {
            // 5. THIS BLOCK WILL BE HIT. Add a print statement to prove it.
            print("‼️ [UserViewModel] CATCH BLOCK HIT. Error: \(error.localizedDescription)")
                    
            // Handle the caught error
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
        let specificError: NetworkError
        
        // Step 1: Normalize the error into a single type
        if let networkError = error as? NetworkError {
            specificError = networkError
        } else {
            specificError = .networkError(error) // Wrap the generic error
        }
        
        // Step 2: Update all state from a single source of truth
        loginState = .error(specificError)
        alertState = .error(message: specificError.errorDescription ?? "An unexpected error occurred.")
        
        print("❌ [UserViewModel] Login state updated to .error. Alert message: \(alertState.message)")
    }
    
    
    private func handleLoginError2(_ error: Error) {
        if let networkError = error as? NetworkError {
            // Path A: Error is already a NetworkError
            loginState = .error(networkError)
            alertState = .error(message: networkError.errorDescription ?? "Unknown error")
        } else {
            // Path B: Error is a generic Error
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
//    
//    func logout() {
//        UserDefaultsManager.shared.logoutUser()
//        clearForm()
//        isLoggedIn = false
//        storedEmail = ""
//        loginState = .idle // Reset the state on logout
//        
//    }
    
    func clearForm() {
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
        return loginState.isLoading
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
