//
//  InsuranceFormView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 18/12/25.
//

import SwiftUI

enum InsuranceField: Int, CaseIterable {
    case provider
    case policynumber
}

struct InsuranceFormView: View {
    
  
    // ✅ Owns its own state
        @StateObject var viewModel: InsuranceFormViewModel
    

   
        let onSaveSuccess : () -> Void
    
        @Environment(\.dismiss) var dismiss
        
    
        @State private var provider = ""
        @State private var number = ""
    
        @FocusState private var focusField: InsuranceField?
    
        var body: some View {
            ZStack{
                NavigationStack {
                    Form {
                        Section {
                            TextField("Provider (e.g. Geico)", text: $provider)
                                .focused($focusField, equals: .provider)
                                .submitLabel(.next)
                                .onSubmit {
                                    focusField = .policynumber
                                }

                            
                            PolicyInputView(value: $number)
                                .frame(height: 44)
                                .focused($focusField, equals: .policynumber)
                                .submitLabel(.done)
                                .onSubmit {
                                    save()
                                }
                            
                        } header: {
                            Text("New \(viewModel.category.rawValue) Policy")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                               
                        }
                        
                        
                        Section {
                            CustomButton1(
                                name: "Save",
                                imgName: "square.and.arrow.down"
                            ) {
                                saveData()
                            }
                            .disabled(provider.isEmpty || number.isEmpty)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .listRowInsets(EdgeInsets())       // remove padding
                            .listRowBackground(Color.clear)    // remove gray background
                        }
                        
                        
                    }
                    .navigationTitle("Add Policy")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") { dismiss() }
                        }
                    }
                }
                
                .presentationDetents([.medium])
                
                // MARK: - State Overlay
                stateOverlay
                
            }
            .toolbar { keyboardToolbar }
            .onAppear {
                    focusField = .provider
                }
            // ✅ SIDE EFFECT HANDLING (BEST PLACE)
            .onChange(of: viewModel.state.isSuccess) { success in
                if success {
                    dismiss()
                    onSaveSuccess()
                }
            }
        
    }
    
    
    private func saveData() {
            Task {
                await viewModel.save(
                    provider: provider,
                    number: number
                )
            }
        }
}

extension InsuranceFormView {
   
    @ViewBuilder
    private var stateOverlay: some View {
        switch viewModel.state {

        case .idle:
            EmptyView()

        case .loading:
            LoaderView(
                isLoading: true,
                message: "Saving policy..."
            )

        case .success:
            EmptyView() // handled via dismiss()

        case .error(let error):
            
            ErrorStateView(error)
        }
    }

}

extension InsuranceFormView {

    private var keyboardToolbar: some ToolbarContent {
        ToolbarItemGroup(placement: .keyboard) {

            Button {
                moveToPreviousField()
            } label: {
                Image(systemName: "chevron.up")
            }

            Button {
                moveToNextField()
            } label: {
                Image(systemName: "chevron.down")
            }

            Spacer()

            Button("Done") {
                focusField = nil
                save()
            }
        }
    }
}

extension InsuranceFormView {

    private func moveToNextField() {
        guard let current = focusField else { return }
        let nextIndex = min(current.rawValue + 1,
                            InsuranceField.allCases.count - 1)
        focusField = InsuranceField(rawValue: nextIndex)
    }

    private func moveToPreviousField() {
        guard let current = focusField else { return }
        let prevIndex = max(current.rawValue - 1, 0)
        focusField = InsuranceField(rawValue: prevIndex)
    }

    private func save() {
        focusField = nil
        Task {
            await viewModel.save(
                provider: provider,
                number: number
            )
        }
    }
}



#Preview {
    
    InsuranceFormView(viewModel:
                        DependencyContainer().makeInsuranceFormViewModel(for: InsuranceType.bike), onSaveSuccess: {
        
    })
}
