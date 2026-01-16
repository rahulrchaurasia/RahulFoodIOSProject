//
//  AgentListView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 07/01/26.
//

import SwiftUI

struct AgentListView: View {
    
    @EnvironmentObject var coordinator : AppCoordinator
    @EnvironmentObject private var appState: AppState

    @StateObject private var viewModel: AgentViewModel
    
    init(agentViewModel: AgentViewModel ) {
        
        _viewModel = StateObject(wrappedValue:agentViewModel)
       
    }
  
    var body: some View {
       
        ZStack{
            
            // Background color
            
            Color(.systemGray6)
                .ignoresSafeArea(.all)
            
            VStack(spacing: 0) {
                
                CustomToolbar(title: "Agent List") {
                    coordinator.navigateBack()
                }
              
                if viewModel.isLoading  {
                    Group{
                        ProgressView("Loading data...")
                            .font(.headline)
                        
                           
                            .padding(20)
                    }
                    
                }
                else{
                    
                    if let data = viewModel.data {
                        
                        VStack(spacing: 0){
                            
                            Text("Agent Name : Done")
                            
                        }
                        
//                        List {
//                            
//                            Section("Details"){
//                                // ✅ Accessing API properties directly
//                                
//                                // ✅ Accessing API properties directly
//                                LabeledContent("Designation", value: data.pospDesignation ?? "-")
//                                LabeledContent("Manager", value: data.managerName ?? "-")
//                                LabeledContent("Support", value: data.supportMobile ?? "-")
//                                
//                            }
//                        }
                    }

                }
             
                Spacer()
            }
           
           
        }
      
        .task {
            await viewModel.fetchConstants()
        }
        .alert("Error",
                      isPresented: $viewModel.showErrorAlert) {
                   Button("OK", role: .cancel) { }
               } message: {
                   Text(viewModel.errorMessage ?? "")
               }
      
    }
}

#Preview {
    
    let container = DependencyContainer()

    AgentListView(agentViewModel: container.makeAgentViewModel())
}
