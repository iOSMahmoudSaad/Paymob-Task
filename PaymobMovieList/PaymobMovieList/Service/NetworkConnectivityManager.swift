//
//  NetworkConnectivityManager.swift
//  PaymobMovieList
//
//  Created by Mahmoud Saad on 19/05/2025.
//

import Foundation
import Network
import Combine

protocol NetworkConnectivityProvider {
    var isConnected: Bool { get }
    var networkStatusPublisher: AnyPublisher<Bool, Never> { get }
    func startMonitoring()
    func stopMonitoring()
}

class NetworkConnectivityManager: NetworkConnectivityProvider {
    static let shared = NetworkConnectivityManager()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor", qos: .background)
    private let networkStatusSubject = CurrentValueSubject<Bool, Never>(false)
    
    private(set) var isConnected: Bool = false
    
    var networkStatusPublisher: AnyPublisher<Bool, Never> {
        return networkStatusSubject.eraseToAnyPublisher()
    }
    
    private init() {
        setupMonitor()
    }
    
    private func setupMonitor() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            let isConnected = path.status == .satisfied
            
            if self.isConnected != isConnected {
                self.isConnected = isConnected
                self.networkStatusSubject.send(isConnected)
            }
        }
    }
    
    func startMonitoring() {
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
    
    deinit {
        stopMonitoring()
    }
}
