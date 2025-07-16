//
//  AuthVM.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 21/11/24.
//

import Foundation
import SwiftUI

@MainActor
final class AuthViewModel : ObservableObject {
    
    // MARK: - Properties
  
   
   
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true
    @AppStorage("userEmail") private var storedEmail: String = ""
    
    private let userRepository: UserRepositoryProtocol
    
    @Published var currentAuthState: AuthState = .onboardingModule
    
    @Published var isLoggedIn : Bool = false
   // @Published var isError : Bool = false
    
    @Published var email: String = String()
    @Published var passWordData: String = String()
    @Published var address : String = String()
    
    @Published var showError = false
    @Published var errorMessage : String?
    
    @Published var showAPIError = false
    @Published var errorAPIMessage : String?
    
    @Published var isLoading : Bool = false
    // Errors for each text field
    @Published private(set)  var fieldErrors: [LoginField1: String] = [:]
    
    
    
    //Focus Field
   
    @Published var errorField: LoginField1? // Track which field has error
    
        
        // Add a state property for user data
        @Published private(set) var userState: ViewState<[User]> = .idle
        
    //007
    // Modified initializer to accept repository
//    init(userRepository: UserRepositoryProtocol = UserRepository(apiService: APIService.init())) {
//        self.userRepository = userRepository
//            // Load saved state
//            email = storedEmail
//            reset()
//    }
    
    init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
    }
    
    // MARK: - Logout
    func logout() {
        // Use UserDefaultsManager to handle all UserDefaults operations
        UserDefaultsManager.shared.logoutUser()
        
        // Reset view model state
        reset()
        
        // Clear local state
        isLoggedIn = false

        print("User logged out successfully")
    }
        
        // Keep your existing reset method or enhance it
        func reset() {
            email = ""
            passWordData = ""
            storedEmail = ""
            // Clear any other stateful properties as needed
        }
    
    
    
    // MARK: - Authentication Methods
    func signIn() async throws -> Bool {
            isLoading = true
            defer { isLoading = false }
            
            do {
                // Simulate network call
                
                if (validAction1() ) {
                 
                    try await Task.sleep(nanoseconds: 1_000_000_000)
                    
                    
                    try await fetchUserByEmail(email)
                    
                    return true
                }
                
            } catch {
                await MainActor.run {
                    showAPIError = true
                    errorMessage = "Invalid User ID or password"
                }
            }
        
           return false
        }
        
      
   
    func completeOnboarding() {
            isFirstLaunch = false
       // updateAuthState(.loginModule)
        }
        
       
    
    //MARK: Error Handling in Dictionary
      private func setError(for field: LoginField1, message: String) {
            fieldErrors[field] = message
        }

        func error(for field: LoginField1) -> String? {
            return fieldErrors[field]
        }

        func hasError(for field: LoginField1) -> Bool {
            return fieldErrors[field] != nil
        }
    
    
    
    //MARK: Action
    
        func validAction1() -> Bool {
          fieldErrors = [:] // Reset errors before validation
            errorField = nil
            errorMessage = ""
            
          if email.isEmpty {
              setError(for: .email, message: "Please enter email")
              errorField = .email
          }
           else if address.isEmpty {
                setError(for: .address, message: "Please enter Address")
               errorField = .address
           }else if passWordData.isEmpty {
              setError(for: .passwordData, message: "Please enter password")
               errorField = .passwordData
          }else if passWordData.count < 3 {
              setError(for: .passwordData, message: "Password is too short...")
              errorField = .passwordData
          }
        
             if let firstError = fieldErrors.first {
                   // Safely unwrap the first error and use it
                   errorMessage = firstError.value
                   showError = true
               } else {
                   showError = false
               }
               
          // Return true if no errors are found
          return fieldErrors.isEmpty
      }
    
    // veridy User
    
    func verifyUser() -> Bool {
        if email == "rahul@gmail.com" && passWordData == "123456" {
            return true
        }else{
            setAPIError(message: "Invalid User ID or password")
            return false
        }
        
    }
    // Validate user inputs
    func validAction() -> Bool {
        if email.isEmpty {
            setError(message: "Please enter Email")
            
            setError(for: .email, message: "Please enter name")
            return false
        }
        if passWordData.isEmpty {
            setError(message: "Please enter Password")
            setError(for: .passwordData, message: "Please enter Password")
            return false
        }
        
        return true
    }
    

    
    // Helper to set error messages
       private func setError(message: String) {
           self.errorMessage = message
           self.showError = true
           
           
       }
    
    private func setAPIError(message: String) {
        self.errorAPIMessage = message
        self.showAPIError = true
    }
    
    
    // Add a method to fetch users
        func fetchUserByEmail(_ email: String) async {
            userState = .loading
            
            
            do {
                let users = try await userRepository.getUserByEmail(email)
                userState = .success(users)
                
                 
                
                // Success
                await MainActor.run {
        
                    reset()
                    storedEmail = email
                     // set User Loggin
                    UserDefaultsManager.shared.username = users[0].name
                    UserDefaultsManager.shared.isLoggedIn = true
                }
            } catch {
                if let networkError = error as? NetworkError {
                    userState = .error(networkError)
                    
                    showAPIError = true
                    errorMessage = "Network error"
                    
                } else {
                    // Convert unknown errors to NetworkError
                    userState = .error(.networkError(error))
                    
                    
                    showAPIError = true
                    errorMessage = "Invalid UserId and Password"
                }
            }
        }
    
    
}


enum LoginField1 : Int, Hashable ,CaseIterable {
   
   case  email
   case passwordData
    case address
  
}
