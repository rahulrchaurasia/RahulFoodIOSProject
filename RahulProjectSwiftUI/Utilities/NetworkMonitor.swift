//
//  NetworkMonitor.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 08/04/25.
//

import Foundation
import Network


class NetworkMonitor : ObservableObject{
    
    @Published private(set) var isConnected = false
    @Published private(set) var connectionType = "Unknown"
    
    private let monitor = NWPathMonitor()
    
    func startMonitoring() {
            monitor.pathUpdateHandler = { [weak self] path in
                DispatchQueue.main.async {
                    // Update connection status
                    self?.isConnected = path.status == .satisfied
                    
                    // Determine connection type
                    if path.usesInterfaceType(.wifi) {
                        self?.connectionType = "WiFi"
                    } else if path.usesInterfaceType(.cellular) {
                        self?.connectionType = "Cellular"
                    } else if path.usesInterfaceType(.wiredEthernet) {
                        self?.connectionType = "Ethernet"
                    } else {
                        self?.connectionType = "Unknown"
                    }
                    
                    // Log status
                    print("Network Status: \(self?.isConnected ?? false)")
                    print("Connection Type: \(self?.connectionType ?? "Unknown")")
                }
            }
            
            monitor.start(queue: DispatchQueue.global())
        }

}
