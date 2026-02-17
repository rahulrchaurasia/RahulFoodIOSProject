//
//  LocationScreen.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 09/02/26.
//

import SwiftUI
import SwiftUI
import CoreLocation

import SwiftUI

struct LocationScreen: View {
    
    @StateObject private var viewModel = LocationViewModel()
    @EnvironmentObject var coordinator: AppCoordinator // Assuming you have this
    
    var body: some View {
        VStack(spacing: 0) {
            
            // Toolbar
            // ✅ ACTION: Reset data when back button is pressed
            CustomToolbar(title: "LOCATION SERVICE", backAction: {
                viewModel.resetData()
                coordinator.navigateBack()
            })
            
            VStack(spacing: 24) {
                // Header
                Image(systemName: "location.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.blue)
                    .padding(.top, 15)
                
                // State Logic
                switch viewModel.state {
                case .idle:
                    Text("Tap the button to start.")
                        .foregroundColor(.secondary)
                    
                case .loading:
                    VStack(spacing: 12) {
                        ProgressView().scaleEffect(1.5)
                        Text("Finding you...")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                case .success(let coordinate):
                    VStack(spacing: 12) {
                        Text("📍 Location Found").font(.headline).foregroundColor(.green)
                        
                        // Professional Formatting
                        Text("\(coordinate.latitude, specifier: "%.4f"), \(coordinate.longitude, specifier: "%.4f")")
                            .font(.system(.title2, design: .monospaced))
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                        
                        
                        // getAddress
                    
                        // ✅ Address display
                        if let address = viewModel.address {
                            
                           
                            Text(address)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        } else {
                            // Shows while geocoding is in progress
                            HStack(spacing: 6) {
                                ProgressView().scaleEffect(0.7)
                                Text("Resolving address...")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                    }
                    
                case .error(let error):
                    VStack(spacing: 8) {
                        Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.red)
                        Text(error.errorDescription ?? "Error").foregroundColor(.red)
                    }
                }
                
                Spacer()
                
                // Button
                Button(action: {
                    viewModel.requestLocation()
                }) {
                    Text("Get Current Location")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(viewModel.state == .loading)
            }
            .padding()
        }
        // ✅ SAFETY: Clears data if the view disappears (tab change, swipe back, etc)
        .onDisappear {
            viewModel.resetData()
        }
        // Alert Logic
        .alert("Permission Required", isPresented: $viewModel.showSettingsAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Settings") { viewModel.openSettings() }
        } message: {
            Text("Please enable location access in Settings.")
        }
    }
}

#Preview {
    LocationScreen()
}
