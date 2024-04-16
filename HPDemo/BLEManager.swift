//
//  BLEManager.swift
//  HPDemo
//
//  Created by Joe Bakalor on 4/16/24.
//

import Foundation
import CoreBluetooth

let AdvService = CBUUID(string: "802A0000-4EF4-4E59-B573-2BED4A4AC159")


protocol BLEManagerProviding {
    func startScan()
    func stopScan()
}

public class BLEManager: NSObject, BLEManagerProviding {
    
    private var centralManager: CBCentralManager?
    
    public override init() {
        super.init()
        var options: [String: Any] = [:]
        options[CBCentralManagerOptionShowPowerAlertKey] = true
        options[CBCentralManagerScanOptionAllowDuplicatesKey] = true
        centralManager = CBCentralManager(delegate: self, queue: nil, options: options)
    }
    
    public func startScan(){
        centralManager?.scanForPeripherals(withServices: [AdvService])
    }
    
    public func stopScan() {
        centralManager?.stopScan()
    }
    
}


extension BLEManager: CBCentralManagerDelegate {
    
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        switch (central.state){
            
        case .unknown:
            print("Unknown")
        case .resetting:
            print("Resetting")
        case .unsupported:
            print("Unsupported")
        case .unauthorized:
            print("Unauthorized")
        case .poweredOff:
            print("Powered Off")
        case .poweredOn:
            print("Powered On")
        @unknown default:
            print("NA")
        }
    }
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if let name = peripheral.name {
            print("Discovered Peripheral: \(name)")
        }
    }
    
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
    }
    
    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: (any Error)?) {
        
    }
    
    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: (any Error)?) {
        
    }
    
}
