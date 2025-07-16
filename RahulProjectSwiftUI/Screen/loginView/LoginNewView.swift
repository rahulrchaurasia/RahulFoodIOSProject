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
struct LoginNewView: View {
    @EnvironmentObject var userVM: UserViewModel
    @EnvironmentObject var router: AppStateRouter
    
    @EnvironmentObject var loginRouter: LoginFlowRouter // 👈 new mini router only for login
    
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
            .disableWithOpacity(userVM.isLoading)
            
            // Loading Indicator
            if userVM.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .scaleEffect(2)
            }
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
        // ↓↓↓ CHANGES HERE - Use isLoginSuccessful instead of loginState ↓↓↓
        .onChange(of: userVM.isLoginSuccessful) { isSuccessful in
            if isSuccessful {
                router.setRoot( .dashboardModule)
            }
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
                loginRouter.navigate(to: .forgotPassword)
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
                loginRouter.navigate(to: .share)
            } label: {
                Label("Sign up with Apple", systemImage: "apple.logo")
            }
            .buttonStyle(CapsuleButtonStyle(bgColor: .black))
            
            Spacer().frame(height: 10)
            
            Button {
                let profile = UserProfile(name: "Rahul", age: 32, gender: .male, designation: "Android Developer")
                router.navigate(to: .profile(userProfile: profile))
                
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
                    textColor: .black,
                    hasBorder: true
                )
            )
        }
    }
    
    private var footerView: some View {
        Button {
            loginRouter.navigate(to: .createAccount(name: "Data From Login"))
        } label: {
            HStack {
                Text("Don't have an account")
                    .foregroundStyle(.black)
                
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
    
    private func handleLoginStateChange(_ newState: ViewState<User>) {
        if case .success = newState {
            // Navigate to dashboard on successful login
            router.setRoot(.dashboardModule)
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
            .environmentObject(Router(container: container))
    }
}
//#Preview {
//    LoginNewView()
//}
