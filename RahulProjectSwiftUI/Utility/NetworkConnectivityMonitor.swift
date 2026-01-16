//
//  NetworkConnectivityMonitor.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 31/12/25.
//

import Combine
import SwiftUI
import Network

protocol ConnectivityMonitor {
    var isConnected: Bool { get }
    var statusPublisher: AnyPublisher<Bool, Never> { get }
}



final class NetworkConnectivityMonitor: ConnectivityMonitor {

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")

    private let subject = CurrentValueSubject<Bool, Never>(true)

    var isConnected: Bool {
        subject.value
    }

    var statusPublisher: AnyPublisher<Bool, Never> {
        subject.eraseToAnyPublisher()
    }

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.subject.send(path.status == .satisfied)
        }
        monitor.start(queue: queue)
    }

    deinit {
        monitor.cancel()
    }
}
