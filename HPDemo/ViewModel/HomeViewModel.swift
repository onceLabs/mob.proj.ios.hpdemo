//
//  HomeViewModel.swift
//  HPDemo
//
//  Created by Joe Bakalor on 4/16/24.
//

import Foundation
import Factory
import Combine

class HomeViewModel: ObservableObject {
    
    @Injected(Container.bleManager) private var bleManager
    
    @Published private(set) var device: BGM220P?
    @Published private(set) var elapsedTime: Int = 0
    @Published private(set) var bytesReceived: Int = 0
    @Published private(set) var throughput: Int = 0
    @Published private(set) var phy: PHY = ._unknown
    @Published private(set) var connectionInterval: Int = 0
    @Published private(set) var slaveLatency: Int = 0
    @Published private(set) var supervisionTimeout: Int = 0
    @Published private(set) var pduSize: Int = 0
    @Published private(set) var mtuSize: Int = 0
    @Published private(set) var testActive: Bool = false
    
    private var bag = Set<AnyCancellable>()
    
    init(){
        bleManager
            .selectedDevicePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] selectedDevice in
                guard let self else { return }
                self.device = selectedDevice
                addPropertyObservers()
            }.store(in: &bag)
    }
    
    func addPropertyObservers(){
        device?
            .$bytesReceived
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] bytesReceived in
                guard let self else { return }
                self.bytesReceived = bytesReceived
            }.store(in: &bag)
        
        device?
            .$phy
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] phy in
                guard let self else { return }
                self.phy = phy
            }.store(in: &bag)
        
        device?
            .$elapsedTime
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] et in
                guard let self else { return }
                self.elapsedTime = et
            }.store(in: &bag)
        
        device?
            .$connectionInterval
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] ci in
                guard let self else { return }
                self.connectionInterval = ci
            }.store(in: &bag)
        
        device?
            .$throughput
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] tp in
                guard let self else { return }
                self.throughput = tp
            }.store(in: &bag)
        
        device?
            .$pduSize
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] pdu in
                guard let self else { return }
                self.pduSize = pdu
            }.store(in: &bag)
        
        device?
            .$mtuSize
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] mtu in
                guard let self else { return }
                self.mtuSize = mtu
            }.store(in: &bag)
        
        device?
            .$supervisionTimeout
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] st in
                guard let self else { return }
                self.supervisionTimeout = st
            }.store(in: &bag)
        
        device?
            .$slaveLatency
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] sl in
                guard let self else { return }
                self.slaveLatency = sl
            }.store(in: &bag)
        
        device?
            .$testActive
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] ta in
                guard let self else { return }
                self.testActive = ta
            }.store(in: &bag)
    }
    
    func startScan(){
        bleManager.startScan()
    }
    
    func stopScan(){
        bleManager.stopScan()
    }

}
