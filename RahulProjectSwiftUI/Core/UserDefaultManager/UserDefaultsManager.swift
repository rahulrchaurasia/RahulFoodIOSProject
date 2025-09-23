//
//  UserDefaultsManager.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 26/12/24.
//

import Foundation


// UserDefaultsManager.swift
final class UserDefaultsManager {
    // Singleton instance
    static let shared = UserDefaultsManager()
    private let defaults = UserDefaults.standard
    
    // Keys
    private enum Keys {
        static let username = "username"
        static let isDarkMode = "isDarkMode"
        static let userSettings = "userSettings"
        static let isLoggedIn = "isLoggedIn"
        static let hasSeenOnboarding = "hasCompletedOnboarding"
        
        // Add this to get all keys
        static var allKeys: [String] {
                return [username, isDarkMode, userSettings, isLoggedIn]
        }
    }
    
    // MARK: - Store user session
    /************************************/

    func saveLoggedInUser(_ user: User) {
        if let encoded = try? JSONEncoder().encode(user) {
            defaults.set(encoded, forKey: "loggedInUser")
        }
    }

    func getLoggedInUser() -> User? {
        guard let data = defaults.data(forKey: "loggedInUser"),
              let user = try? JSONDecoder().decode(User.self, from: data) else {
            return nil
        }
        return user
    }
    
    var loggedInUserName: String {
        getLoggedInUser()?.name ?? ""
    }

    var loggedInUserMobile: String {
        getLoggedInUser()?.mobile ?? ""
    }
    
    var loggedInUserEmail: String {
        getLoggedInUser()?.email ?? ""
    }

    var loggedInUserCity: String {
        getLoggedInUser()?.address.city ?? ""
    }

    var loggedInUserDOB: String {
        getLoggedInUser()?.dob ?? ""
    }

    /************************************/

    
    // MARK: - User Details
    var username: String {
        get { defaults.string(forKey: Keys.username) ?? "" }
        set { defaults.set(newValue, forKey: Keys.username) }
    }
    
    var isDarkMode: Bool {
        get { defaults.bool(forKey: Keys.isDarkMode) }
        set { defaults.set(newValue, forKey: Keys.isDarkMode) }
    }
    
    var isLoggedIn: Bool {
        get { defaults.bool(forKey: Keys.isLoggedIn) }
        set { defaults.set(newValue, forKey: Keys.isLoggedIn) }
    }
    
    var hasSeenOnboarding: Bool {
            get { defaults.bool(forKey: Keys.hasSeenOnboarding) }
            set { defaults.set(newValue, forKey: Keys.hasSeenOnboarding) }
        }
    
    // For complex objects using Codable
    func saveUserSettings(_ settings: UserSettings) {
        if let encoded = try? JSONEncoder().encode(settings) {
            defaults.set(encoded, forKey: Keys.userSettings)
        }
    }
    
    func getUserSettings() -> UserSettings? {
        guard let data = defaults.data(forKey: Keys.userSettings),
              let settings = try? JSONDecoder().decode(UserSettings.self, from: data)
        else { return nil }
        return settings
    }
    
    // MARK: - Logout Function
       func logoutUser() {
           clearAll() // Clear only specific user-related data
           isLoggedIn = false
       }
    
    // Clear all stored data
    func clearAll() {
            Keys.allKeys.forEach { key in
                defaults.removeObject(forKey: key)
            }
    }
    
    
    /// Completely removes all UserDefaults data (use cautiously)
       func clearAllCompletely() {
           if let bundleID = Bundle.main.bundleIdentifier {
               defaults.removePersistentDomain(forName: bundleID)
               defaults.synchronize() // Ensures changes take effect immediately
           }
       }
}

// Your custom settings model
struct UserSettings: Codable {
    var notifications: Bool
    var language: String
    var theme: String
}
