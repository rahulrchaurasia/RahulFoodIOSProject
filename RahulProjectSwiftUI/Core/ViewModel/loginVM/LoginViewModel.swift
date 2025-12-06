//
//  LoginViewModel.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 12/11/25.
//

import Foundation

@MainActor
final class LoginViewModel : ObservableObject {
    
    // MARK: - UI Bindings
    // @Published var isLoading = false
    @Published var registrationState: ViewState<RegisterUserResponse> = .idle
    @Published var alertState = AlertState.hidden
    
    private let repository : LoginRepositoryProtocol
    private let stateRepository: StateRepositoryProtocol
    
    // MARK: - RegisterView Form Fields
    @Published var fullName = ""
    @Published var email = ""
    @Published var mobile = ""
   // @Published var dob = ""
//@Published var dob: Date = Date()         // <-- Store REAL DATE
    // Change from String to Date
    @Published var dob: Date = Calendar.current.date(byAdding: .year, value: -18, to: Date())!
    
    @Published var dobJoin = ""
    @Published var gender = "Male"
    @Published var pincode = ""
    @Published var maritalStatus = "Single"
    @Published var state = ""
    
    
    // MARK: - Error Messages
    @Published var nameError = ""
    @Published var emailError = ""
    @Published var phoneError = ""
    @Published var dobError = ""
    @Published var dobJoinError = ""
    @Published var pincodeError = ""
    
    
    //Mark :-- For StateView
    @Published var states: [String] = []
    @Published var selectedState: String? = nil
    @Published var isLoadingStates = false
    @Published var stateError: String? = nil    // errors
    
    
    // MARK: - Initialization
    init(loginRepository: LoginRepositoryProtocol,stateRepository : StateRepositoryProtocol ) {
        self.repository = loginRepository
        self.stateRepository = stateRepository
    }
    
    //    func updateDOB(_ value: String) {
    //        dob = formatDOB(value)
    //    }
    
    // ✅ This function applies the masking and updates the bound property
    func updateDOB(_ newValue: String) {
        
        // 1. Get the newly formatted/masked string
        let maskedValue = formatDOB(newValue)
        
        // 2. Only update if the value is different (prevents infinite loop warnings)
        if self.dobJoin != maskedValue {
            self.dobJoin = maskedValue
        }
    }
    
    // Your existing formatting logic (moved inside the extension for context)
    func formatDOB(_ value: String) -> String {
        // 1. Strip all non-digit characters
        let numbers = value.filter(\.isNumber)
        var result = ""
        
        // 2. Iterate and insert dashes at position 2 and 4
        for (index, digit) in numbers.enumerated() {
            if index == 2 || index == 4 { result.append("-") }
            result.append(digit)
            
            // 3. Stop at the maximum length of 10 characters (DD-MM-YYYY)
            if result.count == 10 { break }
        }
        return result
    }
    
    func validateDOB() {
            let calendar = Calendar.current
            let age = calendar.dateComponents([ .year ], from: dob, to: Date()).year ?? 0

            if age < 18 {
                dobError = "You must be at least 18 years old"
            } else if age > 100 {
                dobError = "Invalid date of birth"
            } else {
                dobError = ""
            }
        }
    
    func registerUser() async {
        
        
        // 1️⃣ Validation first
          resetAllErrors()
        
        guard validateFields() else { return }  // ✅ validation first
        
        // 2️⃣ Prevent duplicate registration
        guard registrationState != .loading else { return }
        
        // 3️⃣ Set state to loading
        registrationState = .loading
        
        // ⏳ Add 2-second artificial delay
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        do {
            
            let request = RegisterUserRequest(
                city: "Mumbai",
                company: "MyCompany",
                country: "India",
                dob: dob.toDOBString,
                email: email,
                fullname: fullName,
                gender: gender,
                marital_status: maritalStatus,
                mobile: mobile,
                occupation: "Engineer",
                pincode: "400001",
                state: state,
                street: "Some Street"
            )
            
            let response  = try await repository.registerUser(request)
            
            registrationState = .success(response)
            
            print("✅ User registered:", response.Message)
        }catch{
            
            
            registrationState = .error(.networkError(error))
            print("❌ Error registering user:", error.localizedDescription)
        }
        
        
    }
    
    
    // MARK: - Validation Logic (✅ In ViewModel)
    
    func validateFields1() -> Bool {
        
        // 1 - name
        if let err = Validator.validateName(fullName) {
            nameError = err.localizedDescription
            return false
        } else { nameError = "" }
        
        // 2 - email
        if let err = Validator.validateEmail(email) {
            emailError = err.localizedDescription
            return false
        } else { emailError = "" }
        
        // 3 - phone
        if let err = Validator.validatePhone(mobile) {
            phoneError = err.localizedDescription
            return false
        } else { phoneError = "" }
        
        // 4 - dob
        if let err = Validator.validateDOB(dobJoin) {
            dobJoinError = err.localizedDescription
            return false
        } else { dobJoinError = "" }
        
        
        // 5 - pincode
        if let err = Validator.validatePincode(pincode){
            
            pincodeError = err.localizedDescription
            return false
        }else {pincodeError = "" }
        
        // 6 - state
        if let err = Validator.validateState(state) {
            stateError = err.localizedDescription
            return false
        } else {
            stateError = nil
        }
        return true
    }
    
   
    func validateFields() -> Bool {
        
        // Calling getFirstErrorField() performs all the validation side-effects (setting error messages)
            // and returns nil only if validation passes.
            return getFirstErrorField() == nil
    }
    // New function to determine the first error field
    func getFirstErrorField() -> RegisterField? {
        // 1 - fullName
        if let err = Validator.validateName(fullName) {
            nameError = err.localizedDescription
            return .fullName // 👈 Return the field that failed
        } else { nameError = "" }
        
        // 2 - email
        if let err = Validator.validateEmail(email) {
            emailError = err.localizedDescription
            return .email // 👈 Return the field that failed
        } else { emailError = "" }
        
        // 3 - mobile
        if let err = Validator.validatePhone(mobile) {
            phoneError = err.localizedDescription
            return .mobile
        } else { phoneError = "" }
        
        // 4 - dobJoin
        if let err = Validator.validateDOB(dobJoin) {
            dobJoinError = err.localizedDescription
            return .joinDate // Note: using .joinDate for dobJoin
        } else { dobJoinError = "" }
        
        // 5 - pincode
        if let err = Validator.validatePincode(pincode){
            pincodeError = err.localizedDescription
            return .pincode
        }else {pincodeError = "" }
        
        // 6 - state (Assuming StateSelectionView uses StateRepository logic,
        // it's the last field but we return the state error here)
        if let err = Validator.validateState(state) {
            stateError = err.localizedDescription
           
        } else {
            stateError = nil
        }
        
        return nil // All fields are valid
    }

    
    func resetAllErrors() {
        nameError = ""
        emailError = ""
        phoneError = ""
        dobError = ""
        dobJoinError = ""
        pincodeError = ""
        stateError = nil
    }

    
    func fetchStates ()  async {
        
        
        guard states.isEmpty else {return}
        
        isLoadingStates = true
        stateError = nil
        
        do {
            states = try await stateRepository.fetchStateList()
        }
        catch {
            stateError = error.localizedDescription
        }
        isLoadingStates = false
    }
}
