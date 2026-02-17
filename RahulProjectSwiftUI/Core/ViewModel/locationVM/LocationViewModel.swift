//
//  LocationViewModel.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 09/02/26.
//

import Foundation

import CoreLocation
import SwiftUI

// 1. Rename to avoid conflicts with other ViewModels
enum LocationViewState: Equatable {
    case idle
    case loading
    case success(CLLocationCoordinate2D)
    case error(LocationError) // Human readable error message
    
    // 2. MANUALLY Implement Equatable
    // (Required because CLLocationCoordinate2D does not support '==' by default)
    static func == (lhs: LocationViewState, rhs: LocationViewState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle): return true
        case (.loading, .loading): return true
        case (.error(let a), .error(let b)): return a == b
        case (.success(let a), .success(let b)):
            // Compare latitude and longitude manually
            return a.latitude == b.latitude && a.longitude == b.longitude
        default: return false
        }
    }
}

/*
 CLLocationManagerDelegate methods are nonisolated, so marking the ViewModel as @MainActor causes a protocol conformance error in Swift 6. The correct approach is to remove @MainActor from the class and manually hop to the MainActor when updating @Published UI state using Task { @MainActor in }. This prevents data races while maintaining concurrency safety.
 */


// 2. The ViewModel
@MainActor
final class LocationViewModel: NSObject, ObservableObject {
    
    @Published private(set) var state: LocationViewState = .idle
    @Published var showSettingsAlert = false
    
    @Published private(set) var address: String? = nil  // ✅ Declare it here
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    // MARK: - Public Actions
    
    func requestLocation() {
        // Show loading immediately for better UX
        state = .loading
        
        // Fix for "UI Unresponsiveness": Check hardware on background thread
        Task {
            let isEnabled = await Task.detached(priority: .userInitiated) {
                return CLLocationManager.locationServicesEnabled()
            }.value
            
            // Back on Main Thread automatically
            if !isEnabled {
                state = .error(.servicesDisabled)
                return
            }
            
            // If hardware is on, check permissions
            checkPermissionAndRequest()
        }
    }
    
    // ✅ NEW: Call this to clear data when user leaves screen
    func resetData() {
        // Stop any pending updates to save battery
        locationManager.stopUpdatingLocation()
        // DESTROYS the .success data and switches to "Start" screen
        state = .idle
    }
    
    func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
    
    // MARK: - Internal Logic
    
    private func checkPermissionAndRequest() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            state = .error(.permissionRestricted)
        case .denied:
            state = .error(.permissionDenied)
            showSettingsAlert = true
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        @unknown default:
            state = .error(.unknown)
        }
    }
    
    func getAddress(lat: Double, lon: Double) async -> String? {
        let location = CLLocation(latitude: lat, longitude: lon)
        let geocoder = CLGeocoder()
        
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            guard let placemark = placemarks.first else { return nil }
            
            let components: [String?] = [
                placemark.name,                   // Building name
                placemark.subThoroughfare,        // House number
                placemark.thoroughfare,           // Street
                placemark.subLocality,            // Area
                placemark.locality,               // City
                placemark.subAdministrativeArea,  // District
                placemark.administrativeArea,     // State
                placemark.postalCode,
                placemark.country
            ]
            
            return components
                .compactMap { $0 }
                .filter { !$0.isEmpty }
                .joined(separator: ", ")
            
        } catch {
            return nil
        }
    }

    func getAddress2(lat: Double, lon: Double) async -> String? {
        let location = CLLocation(latitude: lat, longitude: lon)
        let geocoder = CLGeocoder()
        
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            guard let placemark = placemarks.first else { return nil }
            
            // compactMap removes nil AND empty strings automatically
            let components: [String?] = [
                placemark.thoroughfare,        // "123 Main St"
                placemark.locality,            // "New York"
                placemark.administrativeArea,  // "NY"
                placemark.postalCode,          // "10001"
                placemark.country              // "United States"
            ]
            
            let fullAddress = components
                .compactMap { $0 }             // removes nil values
                .filter { !$0.isEmpty }        // removes empty strings
                .joined(separator: ", ")       // "Main St, New York, NY, 10001, United States"
            
            return fullAddress.isEmpty ? nil : fullAddress
            
        } catch {
            return nil
        }
    }
    func getAddress1(lat: Double, lon: Double) async -> String? {
        let location = CLLocation(latitude: lat, longitude: lon)
        let geocoder = CLGeocoder()
        
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            return placemarks.first?.name
        } catch {
            return nil
        }
    }
}

// MARK: - Delegate (Thread Safe Fix)
extension LocationViewModel: CLLocationManagerDelegate {
    
    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Task { @MainActor in
            switch manager.authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse:
                // User clicked "Allow" -> Auto-fetch location
                self.locationManager.requestLocation()
            case .denied:
                self.state = .error(.permissionDenied)
            case .restricted:
                self.state = .error(.permissionRestricted)
            case .notDetermined:
                break // Wait for user input
            default:
                break
            }
        }
    }
    
    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        Task { @MainActor in
            guard let location = locations.last else { return }
            self.state = .success(location.coordinate) // ← 1. State updates first
            
            // ← 2. Then getAddress is called right here
            
            self.address = await self.getAddress(
                lat: location.coordinate.latitude,
                lon: location.coordinate.longitude
            )
        }
    }
    
    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Task { @MainActor in
            // Ignore "Unknown Location" noise
            if let clError = error as? CLError, clError.code == .locationUnknown { return }
            self.state = .error(.unknown)
        }
    }
}
