//
//  LocationService.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 09/02/26.
//

import Foundation
import CoreLocation
import UIKit

/*****************************************

    CoreLocation is OLD API

    Apple designed CLLocationManager long before Swift Concurrency:

    func locationManager(
       _ manager: CLLocationManager,
       didUpdateLocations locations: [CLLocation]
    )


    That means:

    No async

    No await

    Result comes later via delegate

    But modern app code wants THIS
    let location = try await locationService.fetchCurrentLocation()


    Clean, readable, testable, MVVM-friendly.

    So what do we do?

    We wrap the old callback API into a new async function.

    This pattern is called:

    “Async wrapper over delegate-based API”

    And the official Swift tool for this is:

    ✅ withCheckedThrowingContinuation

    The Pattern (Industry Standard)
    Old API (Delegate / Callback)
            ↓
    CheckedContinuation
            ↓
    Modern async/await API
                                    
 ****************************************************** */
// Protocol for Dependency Injection (makes testing easier)
protocol LocationServiceProtocol {
    func requestPermission()
    func fetchCurrentLocation() async throws -> CLLocation
    func openAppSettings()
}


//Swift 6 says: You cannot satisfy a nonisolated requirement with a main-actor isolated method. hence remove @MainActor from class


final class LocationService : NSObject, LocationServiceProtocol {
    
    private let manager = CLLocationManager()
    
    // ⚠️ CRITICAL SAFETY:
        // We keep track of the continuation to bridge 'Delegate' -> 'Async'
    //// Tracks the "Waiting for Location"
    private var continuation: CheckedContinuation<CLLocation, Error>?
    
    override init() {
        
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestPermission(){
        
        if manager.authorizationStatus == .notDetermined {
            manager.requestWhenInUseAuthorization()
        }
    }
    
    func fetchCurrentLocation() async throws -> CLLocation {
        
        switch manager.authorizationStatus {
            
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            throw LocationError.permissionNotDetermined
            
        case .denied:
            throw LocationError.permissionDenied
            
        case .restricted:
            throw LocationError.permissionRestricted
            
        case .authorizedAlways, .authorizedWhenInUse:
            break
            
        @unknown default:
            throw LocationError.unknown
        }
        
        guard continuation == nil else {
            throw LocationError.busy
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            manager.requestLocation()
        }
    }

    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        switch manager.authorizationStatus {
            
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()
            
        case .denied:
            continuation?.resume(throwing: LocationError.permissionDenied)
            continuation = nil
            
        case .restricted:
            continuation?.resume(throwing: LocationError.permissionRestricted)
            continuation = nil
            
        default:
            break
        }
    }

    
    

    func openAppSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString),
                      UIApplication.shared.canOpenURL(url) else { return }
                UIApplication.shared.open(url)
    }
    
    
    
}


// MARK: - Delegate (The Engine Room)
extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 5. Success Handling
        guard let newLocation = locations.last else { return }
        
        // Resume the async task with the location
        continuation?.resume(returning: newLocation)
        
        // ⚠️ CLEANUP:
        // Immediately set to nil so we can run again later.
        // If you don't do this, the next call will fail.
        continuation = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // 6. Error Handling
        
        // Ignore "Unknown Location" (happens briefly while GPS warms up)
        if let clError = error as? CLError, clError.code == .locationUnknown {
            return
        }
        
        // Resume the async task with an error
        continuation?.resume(throwing: error)
        
        // ⚠️ CLEANUP
        continuation = nil
    }
}
