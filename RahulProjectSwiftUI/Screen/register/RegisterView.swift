//
//  RegisterView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 12/11/25.
//

import SwiftUI


/*
 
 ✔ Use ScrollView when your form has multiple fields

 Because:

 Keyboard hides bottom fields

 ScrollView allows user to scroll upward

 .ignoresSafeArea(.keyboard) prevents layout jump

 Example:

 ScrollView {
     VStack { form fields… }
 }
 .ignoresSafeArea(.keyboard)


 ➡ Result
 Stable layout + smooth scrolling + no weird jumps.
 */

/*
 Raw values will be:

 fullName = 0
 email    = 1
 mobile   = 2
 dob      = 3


 That means:

 first field → rawValue == 0

 last field → rawValue == RegisterField.allCases.count - 1
 */
enum RegisterField: Int, Hashable, CaseIterable {
    case fullName
    case email
    case mobile
    //case dob
    case joinDate
    case pincode
}

struct RegisterView: View {
    
    @EnvironmentObject var coordinator : AppCoordinator
    @FocusState private var focusField : RegisterField?
    @EnvironmentObject var appState: AppState
    
    // Add these states for calendar
    @State private var showDOBCalendar = false
    
    @State private var showErrorAlert = false
    
    @State private var dobFocused = false
    
    @State private var errorMessage = ""
    
    // 1. The view now holds a StateObject for the ViewModel
    @StateObject private var viewModel: LoginViewModel
    
    // MARK: - Focus Handling
    
    
    
    // 2. The initializer creates the ViewModel, passing the necessary data
    
    init( viewModel: LoginViewModel) {
        
        _viewModel =  StateObject(wrappedValue: viewModel)
        
    }
    
    var body: some View {
        
        ZStack {
            ScrollViewReader { proxy in
                
                ScrollView {
                    VStack(spacing: 20) {
                        header
                        bodyPersonalDtls(proxy: proxy)
                        bodyAddressDtls(proxy: proxy)
                        submitButton(proxy: proxy)
                    }
                    .padding()
                }
                .onChange(of: focusField) {  newValue in
                    
                    guard let field = newValue else { return }
                    // Scroll to the focused field smoothly
                    withAnimation(.easeInOut) {
                        proxy.scrollTo(field, anchor: .top)
                    }
                }
            }
            .disabled(viewModel.registrationState == .loading)
            
            
            
            // Calendar Sheets
            .sheet(isPresented: $showDOBCalendar) {
                NavigationStack {
                    CalendarView(selectedDate: $viewModel.dob)
                        .navigationTitle("Select Date of Birth")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button("Cancel") {
                                    showDOBCalendar = false
                                    dobFocused = false
                                }
                            }
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button("Done") {
                                    showDOBCalendar = false
                                    dobFocused = false
                                    // Move to next field after selecting date
                                    focusField = .joinDate
                                }
                            }
                        }
                }
                .presentationDetents([.medium, .large])
            }
            
            
            LoaderView(isLoading: viewModel.registrationState == .loading, message: "Register Account")
            
        }
        .task {
            await viewModel.fetchStates()  // 👈 Only called once
        }
        
        //API Response State we tracking : if any change on that it trigger
        .onChange(of: viewModel.registrationState) { newValue in
            handleRegistrationState(newValue)
        }
        
        
        
        .navigationBarHidden(true)
        .toolbar {
            keyboardToolbar
        }
       // .ignoresSafeArea(.keyboard)
        
    }
    
    
}

//Api Handling
extension RegisterView {
    
    private func  handleRegistrationState(_ state : ViewState<RegisterUserResponse>)  {
        
        
        switch state {
            
        case .idle ,.loading:
             
            EmptyView()
       
        case .success( let response):
            
            print("Record save successfully \(response.Message)")
            appState.login()
            
            
        case .error(let error):
            errorMessage = error.localizedDescription
            showErrorAlert = true
        }
        
    }
    
}

extension RegisterView {
    
    private var header: some View {
        VStack {
            HStack {
                Button {
                    coordinator.navigateBack()
                } label: {
                    Image(systemName: "arrow.left")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(Color.appBlackColor)
                        .padding()
                }

                Spacer()

                Text("Register User")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.appBlackColor)
                
                Spacer()
                
                Spacer()
                    .frame(width: 20)
            }
            Divider()
        }
    }
    
    private func submitButton(proxy: ScrollViewProxy) -> some View {
        Button {
            
            
            registerUser(proxy: proxy)
        } label: {
            if viewModel.registrationState  == .loading {
                ProgressView()
                    .frame(maxWidth: .infinity)
            } else {
                Text("Register")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
        }
        .disabled(viewModel.registrationState == .loading)
    }
    
    func registerUser(proxy: ScrollViewProxy) {
        
        
       // Task { await viewModel.registerUser() }
        
        // 1. Check for errors and get the first one that failed
            if let firstErrorField = viewModel.getFirstErrorField() {
                
                // A. Scroll to the field first
                withAnimation {
                    // Anchor .top keeps the field visible even if the keyboard comes up
                    proxy.scrollTo(firstErrorField, anchor: .top)
                }
                
                // B. Set the focus after a short delay (for better animation/cursor placement)
                // We use DispatchQeueue.main.asyncAfter for the delay.
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.focusField = firstErrorField // Set focus to highlight the field
                }
                
                return // Stop the registration process
            }
            
            // 2. If valid, proceed with the API call
            // Note: If you want to use the `Task` logic from your ViewModel,
            // you need to change this function to `async` or use a Task block here.
            Task { await viewModel.registerUser() }
    }


}

extension RegisterView {
    
    // MARK: - Personal Details
    private func bodyPersonalDtls(proxy: ScrollViewProxy) -> some View {
        
        VStack(spacing: 20)   {
            
            
            RoundTextField(
                text: $viewModel.fullName,
                placeholder: "Full Name",
                errorMessage: $viewModel.nameError,
                isError: .constant(!viewModel.nameError.isEmpty)
            )
            .id(RegisterField.fullName)
            .limitInputLength(value: $viewModel.fullName, length: 30)
            .focused($focusField, equals: .fullName)
            .textContentType(.name)
            .submitLabel(.next)
            .onSubmit {
                
                focusField = .email
            }
            
            RoundTextField(
                text: $viewModel.email,
                placeholder: "Email",
                errorMessage: $viewModel.emailError,
                isError: .constant(!viewModel.emailError.isEmpty))
            .id(RegisterField.email)
            .limitInputLength(value: $viewModel.email, length: 30)
            .focused($focusField, equals: .email)
            .textContentType(.emailAddress)
            .keyboardType(.emailAddress)
            .submitLabel(.next)
            .onSubmit {
                
                focusField = .mobile
            }
            
            RoundTextField(
                text: $viewModel.mobile,
                placeholder: "Mobile Number",
                errorMessage: $viewModel.phoneError,
                isError: .constant(!viewModel.phoneError.isEmpty))
            .id(RegisterField.mobile)
            .limitInputLength(value: $viewModel.mobile, length: 10)
            .focused($focusField, equals: .mobile)
            
            .keyboardType(.phonePad)
            .submitLabel(.next)
            .onSubmit {
                
                focusField = .pincode
            }
            
            DOBField(
                dob: $viewModel.dob,
                showCalendar: $showDOBCalendar,
                isFocused: $dobFocused,
                title: "Date of Birth",
                error: viewModel.dobError
            )
            .id("DateOFBirth")
          

         
            RoundMaskedTextField(
                         text: $viewModel.dobJoin,
                         placeholder: "Date Of join DD/MM/YYYY",
                         maskPattern: "##/##/####",
                         keyboardType: .numberPad,
                         errorMessage: $viewModel.dobJoinError,
                         isError: .constant(!viewModel.dobJoinError.isEmpty)
                     )
            
            .limitInputLength(value: $viewModel.dobJoin, length: 10)
            .focused($focusField, equals: .joinDate)
            .textContentType(.none)
            .keyboardType(.numberPad)
//            .dobMask($viewModel.dobJoin)
            .submitLabel(.next)
            // .toolbar { keyboardToolbar } // <-- Required
            .onSubmit {
                
                
                focusField = .pincode
            }
            
//            RoundTextField(
//                text: $viewModel.dobJoin,
//                placeholder: "Date of Join Office (DD-MM-YYYY)",
//                errorMessage: $viewModel.dobJoinError,
//                isError: .constant(!viewModel.dobError.isEmpty))
//            
//            .limitInputLength(value: $viewModel.dobJoin, length: 10)
//            .focused($focusField, equals: .joinDate)
//            .textContentType(.none)
//            .keyboardType(.numberPad)
//            .dobMask($viewModel.dobJoin)
//            .submitLabel(.next)
//            // .toolbar { keyboardToolbar } // <-- Required
//            .onSubmit {
//                
//                
//                focusField = .pincode
//            }
            
        }
    }
    
}

extension RegisterView {
    
    // MARK: - Personal Details
    private func bodyAddressDtls(proxy: ScrollViewProxy) -> some View {
        
        VStack(spacing: 20){
            RoundTextField(text: $viewModel.pincode,
                           placeholder: "Pincode *",
                           errorMessage: $viewModel.pincodeError,
                           isError: .constant(!viewModel.pincodeError.isEmpty)
             )
            
            .id(RegisterField.pincode)
            .limitInputLength(value: $viewModel.pincode, length: 6)
            .focused($focusField, equals: .pincode)
            .textContentType(.none)
            .keyboardType(.numberPad)
   
            .submitLabel(.done)
            
            .onSubmit {
                
                registerUser(proxy: proxy)
                // focusField =  nil
            }
            
            StateSelectionView(
                selectedState: $viewModel.selectedState, // direct binding (String?)
                states: viewModel.states,
                errorMessage: viewModel.stateError,
                isLoading: viewModel.isLoadingStates
            )
            
        }
        
    }
}
    

extension RegisterView {
    
    private var keyboardToolbar: some ToolbarContent {
        ToolbarItemGroup(placement: .keyboard) {
            
            // Done button (always available)
            // Done button (conditionally shown)
           // ToolbarItem(placement: .keyboard) {
                if isLastField {
                    Button("Done") {
                        focusField = nil
                    }
                    .font(.system(size: 18, weight: .semibold))
                    .tint(.brown)
                }
          //  }
            
            Spacer()
            
            Button {
                moveToPreviousField()
            } label: {
                Image(systemName: "chevron.up")
                    .foregroundStyle(Color.appBlackcolor)
            }
            .font(.system(size: 18, weight: .semibold))
            .padding(.horizontal)
            .disabled(isFirstField)
            
            Button {
                moveToNextField()
            } label: {
                Image(systemName: "chevron.down")
                    .foregroundStyle(Color.appBlackcolor)
            }
            .font(.system(size: 18, weight: .semibold))
            .padding(.horizontal)
            .disabled(isLastField)
        }
    }

}

extension RegisterView {
    
    private var currentIndex: Int {
        RegisterField.allCases.firstIndex(of: focusField ?? .fullName) ?? 0
    }
    private var isFirstField: Bool {
        //focusField?.rawValue == 0
        currentIndex == 0
    }

    private var isLastField: Bool {
        //focusField?.rawValue == RegisterField.allCases.count - 1
        currentIndex == RegisterField.allCases.count - 1
    }

    
    func moveToNextField() {
 //       guard let current = focusField else {return}
//
//        let lastIndex = RegisterField.allCases.count - 1
//        let nextIndex = min(current.rawValue + 1, lastIndex)
//        
//        focusField = RegisterField(rawValue: nextIndex)
        
        guard let current = focusField,
                  let index = RegisterField.allCases.firstIndex(of: current) else { return }
            
            let nextIndex = RegisterField.allCases.index(after: index)
            
            if nextIndex < RegisterField.allCases.count {
                focusField = RegisterField.allCases[nextIndex]
            }
        
    }

    func moveToPreviousField() {
//     
//        guard let current = focusField else { return }
//        
//        let prevIndex = max(current.rawValue - 1, 0)
//        
//        focusField = RegisterField(rawValue: prevIndex)
        
        guard let current = focusField,
                  let index = RegisterField.allCases.firstIndex(of: current) else { return }
            
            let prevIndex = RegisterField.allCases.index(before: index)
            
            if prevIndex >= 0 {
                focusField = RegisterField.allCases[prevIndex]
            }
    }

    
}



#Preview {
    
    let container = PreviewDependencies.container
    
    RegisterView(viewModel: container.makeLoginViewModel())
}
