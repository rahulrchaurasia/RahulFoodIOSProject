//
//  StateListView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 17/11/25.
//

import SwiftUI

// Separate Sheet View for the List
struct StateListView: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var selectedState: String?
    let states : [String]
    
    @State private var searchText = ""
    
     var filteredStates: [String] {
            if searchText.isEmpty {
                return states
            } else {
                return states.filter { $0.localizedCaseInsensitiveContains(searchText) }
            }
        }
    
    var body: some View {
      
        NavigationStack {
            List{
                
                ForEach(filteredStates , id: \.self ) { state in
                    
                    Button {
                        
                        selectedState = state
                        dismiss()
                    } label: {
                        
                        HStack {
                            
                            Text(state)
                            Spacer()
                            
                            if selectedState == state {
                                
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.blue)
                            }
                            
                            
                        }
                    }
                    .foregroundStyle(.primary)

                }
            }
            .searchable(text: $searchText)
            .navigationTitle("Select State")
              .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
                Button("Done") {
                    dismiss()
                }
            }
        }
        
    }
}

#Preview {
    @State  var selectedState: String? = nil
    
    let sampleStates = [
        "Maharashtra", "Gujarat", "Rajasthan", "Karnataka",
        "Tamil Nadu", "Kerala", "Punjab", "Haryana", "Bihar"
    ]
    StateListView(selectedState: $selectedState, states: sampleStates
                  
    )
}
