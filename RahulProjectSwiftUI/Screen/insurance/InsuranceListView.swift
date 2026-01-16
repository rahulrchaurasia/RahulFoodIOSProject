//
//  InsuranceListView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 18/12/25.
//

import SwiftUI

struct InsuranceListView: View {
    
    @EnvironmentObject var appState: AppState

    @StateObject var viewModel: InsuranceViewModel
    @EnvironmentObject var coordinator : AppCoordinator
    let container: DependencyContainer          // ✅ ADD THIS
    
    
    init(insuranceViewModel: InsuranceViewModel ,container : DependencyContainer) {
        
        _viewModel = StateObject(wrappedValue:insuranceViewModel)
        self.container = container
    }
    
    
    var body: some View {
        
        ZStack{
            // Background color
            
            Color(.systemGray6)
                .ignoresSafeArea(.all)
            VStack(spacing:0){
                
                CustomToolbar(title: "Insurance",
                              
                              backAction: {
                    coordinator.navigateBack()
                },
                              rightAction : ToolbarAction(
                                icon:"plus",
                                action: {
                                    viewModel.showAddSheet = true
                                }),
                              backgroundColor : Color.systemGray6
                )
                
                
                Text("Insurance").font(.appHeader)
                    .foregroundStyle(Color.primary)
                    .padding()
                Text(appState.isOnline ? "Online" : "Offline").font(.caption)
                
                listSection
               
                Spacer()
                
                Spacer()
                
            }
            
            
        }
        .sheet(isPresented: $viewModel.showAddSheet) {
            
            // ✅ Create the SEPARATE Form ViewModel here
           
            InsuranceFormView(
                viewModel: container.makeInsuranceFormViewModel(for: viewModel.category),
                              
            onSaveSuccess: {
                
                viewModel.loadData()
            })
        }
        .task {
            viewModel.loadData()
        }
        
    }
}

private extension InsuranceListView {
    
   
    var listSection: some View {
        
        Group{
            
            switch viewModel.state {
            case .idle, .loading:
                EmptyView()
            
            case .success(let policies):
                

                
                if policies.isEmpty {
                    // ⚠️ iOS 16 Replacement for ContentUnavailableView
                    VStack(spacing: 20) {
                        Image(systemName: "doc.text")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        
                        Text("No \(viewModel.category.rawValue) Insurance")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Text("Tap + to add a new policy.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    
                }
                
                else {
                    List(policies) { policy in
                        VStack(alignment: .leading) {
                            Text(policy.providerName ?? "Unknown")
                                .font(.headline)
                            Text(policy.policyNumber ?? "---")
                                .font(.caption)
                                .foregroundStyle(.secondary) //
                        }
                    }
                }
                
                
            case .error( _):
               
                EmptyView()
                    .ignoresSafeArea(edges: .top)
            }
        }
      
    }
   
    
}


#Preview {
    InsuranceListView(insuranceViewModel: DependencyContainer().makeInsuranceViewModel(for: InsuranceType.bike), container: DependencyContainer())
}
