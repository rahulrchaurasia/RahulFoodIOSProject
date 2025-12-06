//
//  LoginNewView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 04/04/25.
//

import SwiftUI

import SwiftUI
/*
 //Mark  VVIMP : this is also way to get userViewModel
// @StateObject var userViewModel = UserViewModel(userRepository: UserRepository(apiService: APIService()))

 or
 user global way  userVM: UserViewModel
 */

//***********************************************************************
/*
Where AppState belongs

AppState = global session status (isLoggedIn, hasCompletedOnboarding).

UserViewModel = UI + form state for login screen (fields, validation, login API calls).

👉 So, AppState should not live inside UserViewModel, because:

AppState is global — onboarding, login, home modules all depend on it.

UserViewModel is local — only for login screen.

If you mix them, you create tight coupling → every module would need UserViewModel just to check login state, which is wrong.
 */

//***********************************************************************
struct LoginNewView: View {
    @EnvironmentObject var userVM: UserViewModel

    @EnvironmentObject var appState: AppState
    @EnvironmentObject var coordinator: AppCoordinator
    
    @FocusState private var focusField: LoginField?
    
    // In your parent view:
    //Mark  VVIMP : this is also way to get userViewModel
   // @StateObject var userViewModel = UserViewModel(userRepository: UserRepository(apiService: APIService()))

    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Logo
                    logo
                    
                    // Title
                    title
                    
                    Spacer().frame(height: 10)
                    
                    // Form Fields
                    formFields
                    
                    Spacer().frame(height: 10)
                    
                    // Forgot Password
                    forgotButton
                    
                    Spacer().frame(height: 10)
                    
                    // Login Button
                    loginButton
                    
                    // Separator
                    HStack(spacing: 16) {
                        DividerView()
                        Text("or")
                        DividerView()
                    }
                    .foregroundStyle(.gray)
                    
                    // Social Login Options
                    socialLoginOptions
                    
                    // Footer View
                    footerView
                }
            }
            .scrollIndicators(.hidden)
            .disableWithOpacity(userVM.loginState == .loading)
            
            // PATTERN 1: UI logic
            //Use a ViewStateOverlay (or inline switch) only for UI.
            //UI logic → what to show to the user (spinner, error, empty state).
            
          
            ViewStateOverlay(state: userVM.loginState)
        }
        .alert(userVM.alertState.title, isPresented: $userVM.showError, actions: {
            Button("OK", role: .none, action: {})
        }, message: {
            Text(userVM.errorMessage)
        })
        .navigationTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea()
        .padding()
        .toolbar {
            keyboardToolbar
        }
       
        .onChange(of: userVM.focusedField) { newField in
           // handleFocusChange(newField)
            if newField != focusField {
                focusField = newField
            }
        }
        .onChange(of: focusField) { newField in
            if newField != userVM.focusedField {
                userVM.focusedField = newField
            }
        }
        
        // PATTERN 2: Side effects
        //Use .onChange(of:) or .task only for side effects.
        //  Side effects → what to do when state changes (navigate, trigger API, show toast/alert).
    //  // Side-effect: react when loginState changes
        
        .onChange(of: userVM.loginState) { newState in
            if case .success = newState {
               // router.setRoot(.dashboardModule)
                
                appState.login()
               //  coordinator.completeLogin()
            }
           
//            switch newState {
//            case .success(let user):
//                // 1) Update the global session (single source of truth)
//                guard !appState.isLoggedIn else { return } // idempotency guard
//                appState.login() // persists isLoggedIn
//                
//                // 2) Let coordinator observe AppState and switch flow automatically,
//                //    OR call coordinator directly if you prefer immediate explicit navigation:
//                // coordinator.completeLogin()
//                //
//                // Prefer to let coordinator observe appState for separation of concerns.
//            case .error(let err):
//                // logging/analytics can go here
//                print("Login failed: \(err.localizedDescription)")
//            case .loading, .idle:
//                print("Loading")
//                
//            }
                  
        }
        .onSubmit {
            handleSubmitAction()
        }
        
    }
    
    // MARK: - UI Components
    private var logo: some View {
        Image("a2")
            .resizable()
            .scaledToFit()
            .frame(height: 120)
    }
    
    private var title: some View {
        Text("Let's Connect with Us!")
            .font(.title2)
            .fontWeight(.semibold)
    }
    
    private var formFields: some View {
        VStack(alignment: .leading) {
            // Email Field
            LineTextField(
                placeholder: "Email or Phone Number",
                text: $userVM.email,
                keyboardType: .emailAddress,
                isError: userVM.hasError(for: .email),
                errorMessage: userVM.errorMessage(for: .email),
                isSecureField: false
            )
            .limitInputLength(value: $userVM.email, length: 30)
            .focused($focusField, equals: .email)
            .textContentType(.emailAddress)
            .submitLabel(.next)
            .padding(.bottom, 8)
            
            // Address Field
            LineTextField(
                placeholder: "Address",
                text: $userVM.address,
                keyboardType: .default,
                isError: userVM.hasError(for: .address),
                errorMessage: userVM.errorMessage(for: .address),
                isSecureField: false
            )
            .limitInputLength(value: $userVM.address, length: 30)
            .focused($focusField, equals: .address)
            .submitLabel(.next)
            .padding(.bottom, 8)
            
            // Password Field
            LineTextField(
                placeholder: "Password",
                text: $userVM.password,
                keyboardType: .default,
                isError: userVM.hasError(for: .password),
                errorMessage: userVM.errorMessage(for: .password),
                isSecureField: true
            )
            .limitInputLength(value: $userVM.password, length: 20)
            .focused($focusField, equals: .password)
            .textContentType(.password)
            .submitLabel(.done)
            .padding(.bottom, 8)
        }
    }
    
    private var forgotButton: some View {
        HStack {
            Spacer()
            
            Button {
               // router.navigate(to: .forgotPassword)
               // loginRouter.navigate(to: .forgotPassword)
                
                coordinator.navigate(to: .login(.forgotPassword))
            } label: {
                Text("Forgot Password")
                    .foregroundStyle(.gray)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
        }
    }
    
    private var loginButton: some View {
        Button {
            authenticate()
        } label: {
            Text("Login")
        }
        .buttonStyle(CapsuleButtonStyle())
    }
    
    private var socialLoginOptions: some View {
        VStack(spacing: 10) {
            Button {
                //loginRouter.navigate(to: .share)
                coordinator.navigate(to: .login(.signUp))
            } label: {
                Label("Sign up with Apple", systemImage: "apple.logo")
            }
            .buttonStyle(CapsuleButtonStyle(bgColor: Color.appWhiteColor))
            
            Spacer().frame(height: 10)
            
            Button {
                let profile = UserProfile(name: "Rahul", age: 32, gender: .male, designation: "Android Developer")
               // router.navigate(to: .profile(userProfile: profile))
                
            } label: {
                HStack {
                    Image("check_list")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .scaledToFit()
                    Text("Sign up with Google")
                }
            }
            .buttonStyle(
                CapsuleButtonStyle(
                    bgColor: .clear,
                    textColor: Color.appWhiteColor,
                    hasBorder: true
                )
            )
        }
    }
    
    private var footerView: some View {
        Button {
           // loginRouter.navigate(to: .createAccount(name: "Data From Login"))
            
            coordinator.navigate(to: .login(.registerUser))
        } label: {
            HStack {
                Text("Don't have an account")
                    .foregroundStyle(Color.appBlackColor)
                
                Text("Sign up")
                    .foregroundStyle(.teal)
            }
        }
    }
    
    private var keyboardToolbar: some ToolbarContent {
        ToolbarItemGroup(placement: .keyboard) {
            if focusField == .password {
                Button("Done") {
                    focusField = nil
                    handleSubmitAction()
                }
                .tint(.brown)
            }
            
            Spacer()
            
            Button {
                moveToPreviousField()
            } label: {
                Image(systemName: "chevron.up")
            }
            .padding(.horizontal)
            
            Button {
                moveToNextField()
            } label: {
                Image(systemName: "chevron.down")
            }
            .padding(.horizontal)
        }
    }
    
    // MARK: - Actions : Login Api
    private func authenticate() {
        Task {
            await userVM.login()
        }
    }
    
    private func handleFocusChange(_ newField: LoginField?) {
        if let field = newField {
            focusField = field
            
            // Ensure the field is visible when focused
            withAnimation {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    // Additional scrolling logic if needed
                }
            }
        }
    }
    
    // Not in Used
    private func handleLoginStateChange(_ newState: ViewState<User>) {
        if case .success = newState {
            // Navigate to dashboard on successful login
          //  router.setRoot(.dashboardModule)
            
            // 1. Update appState if you want persistence
                        //  appState.isLoggedIn = true

                          // 2. Tell coordinator to switch flow
                         // coordinator.completeLogin()
        }
    }
    
    // MARK: - Form Navigation
    private func handleSubmitAction() {
        switch focusField {
        case .email:
            focusField = .address
        case .address:
            focusField = .password
        case .password:
            authenticate()
        case .none:
            // No field is focused
            break
        }
    }
    
    private func moveToNextField() {
        guard let currentInput = focusField,
              let lastIndex = LoginField.allCases.last?.rawValue else { return }
        
        let index = min(currentInput.rawValue + 1, lastIndex)
        focusField = LoginField(rawValue: index)
    }
    
    private func moveToPreviousField() {
        guard let currentInput = focusField,
              let firstIndex = LoginField.allCases.first?.rawValue else { return }
        
        let index = max(currentInput.rawValue - 1, firstIndex)
        focusField = LoginField(rawValue: index)
    }
}



// MARK: - Preview
struct LoginNewView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        let container = PreviewDependencies.container
        LoginNewView()
            .environmentObject(UserViewModel())
         
    }
}
//#Preview {
//    LoginNewView()
//}

