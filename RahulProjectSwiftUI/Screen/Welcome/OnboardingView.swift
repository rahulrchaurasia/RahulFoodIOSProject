//
//  OnboardingView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 02/01/25.
//

import SwiftUI

struct OnboardingView: View {
    
    // router.setRoot(_root: .loginModule)
    // @EnvironmentObject var authVM : AuthViewModel
   // @EnvironmentObject var router : AppStateRouter

    @StateObject private var vm = OnboardingViewModel()
    
    @EnvironmentObject private var appState: AppState  // 👈 inject global app state
    @EnvironmentObject private var coordinator : AppCoordinator
    
    
    var body: some View {
       
        ZStack{
            // Main Content
            
            TabView(selection: $vm.currentPage) {
                
                ForEach(vm.items.indices, id: \.self ) {index in
                    OnboardingPageView(item: vm.items[index])
                                        .tag(index)
                    }
            }
            .tabViewStyle(PageTabViewStyle())
            
     
            VStack {
                    Spacer()
                    
                    // Custom Page Indicator
                    HStack(spacing: 8) {
                        ForEach(0..<vm.items.count, id: \.self) { index in
                            Capsule()
                                .fill(vm.currentPage == index ? Color.blue : Color.gray.opacity(0.5))
                                .frame(width: vm.currentPage == index ? 20 : 10, height: 8)
                        }
                    }
                    .padding(.bottom)
                    
                    // Buttons
                HStack {
                    if !vm.isLastPage {
                        
                        Button {
                            //set loginModule
                            completeOnboarding()
                          //  router.setRoot( .loginModule)
                        } label: {
                            Text("Skip")
                                .foregroundColor(.blue)
                                .padding()
                        }
                        .padding()
                        
                        Spacer()
                        
                        Button("Next") {
                            vm.nextPage()
                        }
                        .padding()
                    }
                    else {
                        Button("Get Started") {
                            completeOnboarding()
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                    }
                }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
            
        }
    }
    
    
    private func completeOnboarding() {
           appState.completeOnboarding()      // ✅ persist onboarding done
           coordinator.completeOnboarding()   // ✅ switch flow to login
       }
}

#Preview {
    OnboardingView()
}
