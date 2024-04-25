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
    func getConnectedPeripherals() -> [Peripheral]
    var selectedDevicePublisher: Published<BGM220P?>.Publisher { get }
}

public class BLEManager: NSObject, BLEManagerProviding {
    
    @Published private var selectedDevice: BGM220P?
    var selectedDevicePublisher: Published<BGM220P?>.Publisher {$selectedDevice}
    private var btReady = false
    private var centralManager: CBCentralManager?
    private var peripherals : [UUID: Peripheral] = [:]
    
    public override init() {
        super.init()
        var options: [String: Any] = [:]
        options[CBCentralManagerOptionShowPowerAlertKey] = true
        options[CBCentralManagerScanOptionAllowDuplicatesKey] = true
        centralManager = CBCentralManager(delegate: self, queue: nil, options: options)
    }
    
    public func startScan(){
        if (!btReady){
            print("Tried to start scanning before Bluetooth initialized")
        }
        // Permissions request would be triggered here
        centralManager?.scanForPeripherals(withServices: [])
    }
    
    public func stopScan() {
        centralManager?.stopScan()
    }
    
    public func getConnectedPeripherals() -> [Peripheral] {
        return peripherals.values.filter { $0.isConnected() }
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
            // print("Discovered Peripheral: \(name)")
            // Check if name matches "Throughput Test"
            if name == "Throughput Test" {
                print("Found Throughput Test")
                // Add to peripherals
                if let newPeripheral = BGM220P(peripheral: peripheral, advData: advertisementData) as (any Peripheral)? {
                    peripherals[peripheral.identifier] = newPeripheral
                    stopScan()
                    centralManager?.connect(peripheral)
                }
            }
        }
    }
    
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to Peripheral")
        // Check if peripheral is in peripherals
        if let peripheral = peripherals[peripheral.identifier] as? BGM220P{
            selectedDevice = peripheral
            peripheral.didConnect()
        }
    }
    
    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: (any Error)?) {
        print("Failed to connect to Peripheral")
        // Check if peripheral is in peripherals
        if let peripheral = peripherals[peripheral.identifier] {
            peripheral.didDisconnect()
        }
    }
    
    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: (any Error)?) {
        print("Disconnected from Peripheral")
        // Check if peripheral is in peripherals
        if let peripheral = peripherals[peripheral.identifier] {
            peripheral.didDisconnect()
        }
    }
    
}
