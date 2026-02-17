//
//  LocationError.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 09/02/26.
//

import Foundation




enum LocationError: LocalizedError, Equatable {
    case permissionDenied
    case permissionRestricted
    case permissionNotDetermined
    case servicesDisabled
    case busy
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .permissionDenied: return "Permission Denied"
        case .permissionRestricted: return "Location Restricted"
        case .permissionNotDetermined: return "Permission Not Determined"
        case .servicesDisabled: return "Location Services Disabled"
        case .busy: return "Location request already in progress"
        case .unknown: return "Unknown Error"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .permissionDenied, .permissionRestricted:
            return "Please enable location in Settings."
        case .permissionNotDetermined:
            return "We need to ask for permission first."
        case .servicesDisabled:
            return "Turn on Location Services in System Settings."
        case .busy:
            return "Please wait."
        default:
            return "Try again later."
        }
    }
}

