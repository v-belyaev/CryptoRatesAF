//
//  ConnectionCheck.swift
//  CryptoRatesAF
//
//  Created by Владимир Беляев on 17.01.2021.
//

import Foundation
import Network

class ConnectionCheck: NSObject {
    // MARK: - Properties
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "Connection monitor")
    @objc dynamic private(set) var isWorking: Bool = true
    
    // MARK: - Singleton
    static let shared: ConnectionCheck = {
        return ConnectionCheck()
    }()
    
    // MARK: - Init/Deinit
    private override init() {
        super.init()
        setupHandler()
        startInQueue()
    }
    
    deinit {}
    
    // MARK: - Methods
    private func setupHandler() {
        monitor.pathUpdateHandler = {[unowned self] path in
            guard path.status == .satisfied else {
                self.isWorking = false
                return
            }
            self.isWorking = true
        }
    }
    
    private func startInQueue() {
        monitor.start(queue: queue)
    }
}
