//
//  AppearanceSettingsView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 01/01/26.
//

import SwiftUI

struct AppearanceSettingsView: View {
    
    @EnvironmentObject var coordinator : AppCoordinator
    @EnvironmentObject private var appState: AppState
    var body: some View {
       
        ZStack{
            
            // Background color
            
            Color(.systemGray6)
                .ignoresSafeArea(.all)
            
            VStack(spacing: 0) {
                
                CustomToolbar(title: "Setting") {
                    coordinator.navigateBack()
                }
                
                List{
                    Section {
                        ForEach(ThemePreference.allCases){ theme in
                            
                            themeRow(theme)
                          
                            
                        }
                    } footer: {
                        Text("Choose how the app appears. System Default will automatically adapt to your device settings.")
                    }
                }
            }
        }
      
        
      
    }
    
    private func themeRow (_ theme : ThemePreference) -> some View {
        
        Button {
            appState.setTheme(theme)
        }
        label: {
            HStack(spacing:16){
                
                Image(systemName: theme.iconName)
                    .frame(width: 24)
                    .foregroundStyle(.appgreen)
                
                Text(theme.displayName)
                    .font(.headline)
                
                Spacer()
           
                
                if theme == appState.themePreference {
                    Image(systemName: "checkmark")
                        .foregroundColor(.accentColor)
                }
                
                
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
      

    }
}

#Preview {
    
    let container = DependencyContainer()
    
    AppearanceSettingsView()
        .environmentObject(
            AppState(
                connectivityMonitor: container.connectivityMonitor
            )
        )
}
