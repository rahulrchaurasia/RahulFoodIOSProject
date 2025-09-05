//
//  LoginView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 17/11/24.
//

import SwiftUI

struct LoginView: View {
    
//    @State var email: String = ""
//    @State var password: String = ""
    @EnvironmentObject var authVM : AuthViewModel
    @EnvironmentObject var router : Router
    
  //  @FocusState private var focusField : LoginField?
    
    @FocusState  var focusField : LoginField1?
    
    var body: some View {
       
        
        ZStack{
            ScrollView{
                
//                VStack(spacing: 16){
//                    
//                    //logo
//                    logo
//                    
//                    //title
//                    title
//                    
//                    Spacer().frame(height: 10)
//                    
//                    //textField
//                    
//                    description
//                    
//                    Spacer().frame(height: 10)
//                    
//                  
//                    //forgot Button
//                    
//                    forgotButton
//                    
//                    Spacer().frame(height: 10)
//                    
//                    //Login Button
//                    
//                    
//                    
//                    Button {
//                        
//                        demo()
//                        authenticate()
//                    }
//                    label: {
//                        Text("Login")
//                        
//                    }
//                    .buttonStyle(CapsuleButtonStyle())
//                    
//                    
//                    //bottom View
//                    
//                    HStack(spacing: 16) {
//                        DividerView()
//                        Text("or")
//                        DividerView()
//                    }
//                    .foregroundStyle(.gray)
//                    
//                    Button {
//                        
//                        router.navigate(to: .share)
//                    }
//                    label: {
//                        
//                        Label("Sign up with Apple", systemImage: "apple.logo")
//                        
//                    }
//                  .buttonStyle(CapsuleButtonStyle(bgColor: .black))
//                    
//                    Spacer().frame(height: 10)
//                    
//                    Button {
//                        
//                        let profile = UserProfile(name: "Rahul", age: 32, gender: .male, designation: "Android Developer")
//                        router.navigate(to: .profile(userProfile: profile))
//                    } label: {
//                        
//                        HStack{
//                            Image("check_list")
//                                .resizable()
//                                .frame(width: 15, height: 15)
//                                .scaledToFit()
//                            Text("Sign up with Google")
//                        }
//                    }
//                    .buttonStyle(
//                        CapsuleButtonStyle(
//                            bgColor: .clear,
//                            textColor: .black,
//                            hasBorder: true
//                        )
//                    )
//                    
//                  
//                    //footer View
//                    
//                    footerView
//
//                }
                
            }
//            .scrollIndicators(.hidden)
//            
//            .disableWithOpacity(authVM.loginState == .loading )
//            
//
//            switch authVM.userState {
//            case .idle:
//                EmptyView()
//                
//            case .loading:
//                ProgressView("Loading...")
//                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
//                    .scaleEffect(2)
//                
//            case .success(let users):
//                EmptyView()
//                
//            case .error(let error):
//                Text("Error: \(error.localizedDescription)")
//                    .foregroundColor(.red)
//            }
        }
        
        .alert("Authentication", isPresented: $authVM.showError, actions: {
            Button("OK", role:.none, action: {})
        }, message: {
            
            Text(authVM.errorMessage ?? "")
        })
        .navigationTitle("")
       .navigationBarHidden(true)
       .navigationBarBackButtonHidden(true) //
       .ignoresSafeArea()
       //.padding(.vertical,8)
       .padding()
       .toolbar {
           ToolbarItemGroup(placement: .keyboard) {
              
               if(focusField == .passwordData
               ){
                   Button("Done"){
                   
                       focusField = nil
                       print("Done Click")
                       handleSubmitLabel()
                   }.tint(.brown)
                 
               }
             
               
               Spacer()
               Button {
                   print("Previous Click")
                 previous()
               } label: {
                 Image(systemName: "chevron.up")
               }.padding(.horizontal)

               Button {
                   print("next Click")
                 next()
               } label: {
                 Image(systemName: "chevron.down")
               }.padding(.horizontal)

           }
           
           
           
       }
       .onChange(of: authVM.errorField) { newField in
           
           if let field = newField{
               
               focusField = field
               
               // Ensure the field is visible when focused
               
               withAnimation {
                   
                   DispatchQueue.main.asyncAfter(deadline: .now()+0.5){
                       
                   }
               }
           }
       }
       .onSubmit {
           handleSubmitLabel()
       }
        
    }
    
    
    
    
    private var logo : some View{
        
        Image("a2")
            .resizable()
            .scaledToFit()
            .frame(height: 120)
    }
    
    private var title : some View{
        
        Text("Lets Connect with Us!")
            .font(.title2)
            .fontWeight(.semibold)

    }
    
    private var description : some View{
        
        VStack(alignment: .leading){
            
            
            LineTextField(
                          placeholder: "Email or Phone Number",
                          text: $authVM.email, keyboardType: .emailAddress , isError: authVM.hasError(for: .email),
                errorMessage: authVM.errorMessage,
                isSecureField: false)
            .limitInputLength(value: $authVM.email, length: 30)
               
            .focused($focusField,equals: .email)
                .textContentType(.emailAddress)
                .submitLabel(.next)  // Use "Next" for email
//                .onSubmit {
//
//                    focusedField = .mobileNo
//                }
            
           
                .padding(.bottom,8)
 
            ///
         
            LineTextField(
                          placeholder: "Address",
                          text: $authVM.address, keyboardType: .default , isError: authVM.hasError(for: .address),
                errorMessage: authVM.errorMessage,
                isSecureField: false)
            .limitInputLength(value: $authVM.address, length: 30)
               
            .focused($focusField,equals: .address)
                .textContentType(.emailAddress)
                .submitLabel(.next)  // Use "Next" for email
//                .onSubmit {
//
//                    focusedField = .mobileNo
//                }
            
           
                .padding(.bottom,8)
            ///
           
            
            LineTextField(
                          placeholder: "Password",
                          text: $authVM.passWordData, keyboardType: .default , isError: authVM.hasError(for: .passwordData),
                errorMessage: authVM.errorMessage,
                          isSecureField: true)
            .limitInputLength(value: $authVM.passWordData, length: 20)
               
            .focused($focusField,equals: .passwordData)
            .textContentType(.password)
                .submitLabel(.next)  // Use "Next" for email
//                .onSubmit {
//
//                    focusedField = .mobileNo
//                }
            
           
                .padding(.bottom,8)
            
            
            if authVM.showAPIError {
                Text(authVM.errorAPIMessage ?? "")
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.red) }
        }
    }
    
    private var forgotButton :some View {
        
        HStack {
            Spacer()
            
            Button {
                
                router.navigate(to: .forgotPassword)
            } label: {
                Text("Forgot Password")
                    .foregroundStyle(.gray)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }

            

        
        }
    }
    
    private var footerView :some View{
        
        
        Button {
            router.navigate(to: .createAccount(name: "Data From Login"))
        } label: {
            HStack{
                
                Text("Donot have an account")
                    .foregroundStyle(.black)
                
                Text("Sign up")
                    .foregroundStyle(.teal)
            }
        }

        
    }
    
    private func authenticate(){
        //
//        if(result){
//            router.setRoot(_root: .dashboardModule)
//        }
        Task {
            do {
             try await authVM.signIn()
                
               
            } catch {
                // Handle error
            }
        }
        
        
    }
    
    private func demo(){
        
        var suitCase = SuitCase(color: "purple", weight: 90)
        
       
        suitCase.weight = 80
      
        print("Color: \(suitCase.color), Weight: \(suitCase.weight)")
        
        
    
    }
    
    
}

private extension LoginView {
    
    func  handleSubmitLabel() {
        
        switch focusField {
            
        case .email:
        // Move focus to the password field on "Next"

            focusField = .passwordData
            
            
        case .passwordData:
            // Validate on "Done"
            
            authenticate()

            
        case .address:
            focusField = .passwordData
        case .none:
            
            print("none")
        }
        
       
        
    }
}

private extension LoginView {
    
    
    
    
    func next(){
        
        guard let currentInput = focusField ,
              let lastIndex = LoginField1.allCases.last?.rawValue else{return}
        
        
        let index = min(currentInput.rawValue + 1 , lastIndex )
        
        self.focusField = LoginField1(rawValue: index)
    }
    
    func previous(){
        
        guard let currentInput = focusField,
              let lastIndex = LoginField1.allCases.first?.rawValue else{return}
        
        //max(-1,0 ) give = 0 so it will not go out of range
        let index = max(currentInput.rawValue - 1 , lastIndex )
      
        self.focusField = LoginField1(rawValue: index)
    }
}
#Preview {
    LoginView()
        .environmentObject(AuthViewModel(userRepository: DependencyContainer().userRepository))
    
        
}







