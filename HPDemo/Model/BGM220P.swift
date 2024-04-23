//
//  BGM220P.swift
//  HPDemo
//
//  Created by Joe Bakalor on 4/16/24.
//

import Foundation
import CoreBluetooth


public protocol Peripheral {
    func didConnect()
    func didDisconnect()
    func isConnected() -> Bool
}

open class BGM220P: NSObject, Peripheral {
    
    private var gatt: BGM220PGatt = BGM220PGatt()
    private var cbPeripheralRef: CBPeripheral?
    private var startTimeStam: Date?
    private var stopTimeStamp: Date?
    
    // Published properties
    @Published var elapsedTime: Int = 0
    @Published var bytesReceived: Int = 0
    @Published var throughput: Int = 0
    @Published var phy: PHY = ._unknown
    @Published var connectionInterval: Int = 0
    @Published var slaveLatency: Int = 0
    @Published var supervisionTimeout: Int = 0
    @Published var pduSize: Int = 0
    @Published var mtuSize: Int = 0
    @Published var testActive: Bool = false
    
    private var peripheralUUID: UUID? {
        return cbPeripheralRef?.identifier
    }
    
    init(peripheral: CBPeripheral, advData: [String : Any]) {
        super.init()
        cbPeripheralRef = peripheral
        cbPeripheralRef?.delegate = self
    }

    public func didConnect() {
        print("Connected to BGM220P")
        //Start discovering services
        cbPeripheralRef?.discoverServices(nil)
    }

    public func didDisconnect() {
        print("Disconnected from BGM220P")
    }

    public func isConnected() -> Bool {
        return cbPeripheralRef?.state == .connected
    }
    
    public func readThroughputInformation(){
        
        if let connectionPhyCharacteristic = gatt.connectionPhyCharacteristic {
            cbPeripheralRef?.readValue(for: connectionPhyCharacteristic)
        }
        
        if let connectionIntervalCharacteristic = gatt.connectionIntervalCharacteristic {
            cbPeripheralRef?.readValue(for: connectionIntervalCharacteristic)
        }
        
        if let responderLatencyCharacteristic = gatt.responderLatencyCharacteristic {
            cbPeripheralRef?.readValue(for: responderLatencyCharacteristic)
        }
        
        if let supervisionTimeoutCharacteristic = gatt.supervisionTimeoutCharacteristic {
            cbPeripheralRef?.readValue(for: supervisionTimeoutCharacteristic)
        }
        
        if let pduSizeCharacteristic = gatt.pduSizeCharacteristic {
            cbPeripheralRef?.readValue(for: pduSizeCharacteristic)
        }
        
        if let mtuSizeCharacteristic = gatt.mtuSizeCharacteristic {
            cbPeripheralRef?.readValue(for: mtuSizeCharacteristic)
        }

    }
    
    private func enableNotifications(){
        // Enable notifications for indications characteristic
        if let indicationsCharacteristic = gatt.indicationsCharacteristic {
            cbPeripheralRef?.setNotifyValue(true, for: indicationsCharacteristic)
        }

        // Enable notifications for notifications characteristic
        if let notificationsCharacteristic = gatt.notificationsCharacteristic {
            cbPeripheralRef?.setNotifyValue(true, for: notificationsCharacteristic)
        }

        // Enable notifications for transmission on characteristic
        if let transmissionOnCharacteristic = gatt.transmissionOnCharacteristic {
            cbPeripheralRef?.setNotifyValue(true, for: transmissionOnCharacteristic)
        }

        // Enable notifications for throughput result characteristic
        if let throughputResultCharacteristic = gatt.throughputResultCharacteristic {
            cbPeripheralRef?.setNotifyValue(true, for: throughputResultCharacteristic)
        }

        // Enable notifications for connection phy characteristic
        if let connectionPhyCharacteristic = gatt.connectionPhyCharacteristic {
            cbPeripheralRef?.setNotifyValue(true, for: connectionPhyCharacteristic)
        }

        // Enable notifications for connection interval characteristic
        if let connectionIntervalCharacteristic = gatt.connectionIntervalCharacteristic {
            cbPeripheralRef?.setNotifyValue(true, for: connectionIntervalCharacteristic)
        }

        // Enable notifications for responder latency characteristic
        if let responderLatencyCharacteristic = gatt.responderLatencyCharacteristic {
            cbPeripheralRef?.setNotifyValue(true, for: responderLatencyCharacteristic)
        }

        // Enable notifications for pdu size characteristic
        if let pduSizeCharacteristic = gatt.pduSizeCharacteristic {
            cbPeripheralRef?.setNotifyValue(true, for: pduSizeCharacteristic)
        }

        // Enable notifications for mtu size characteristic
        if let mtuSizeCharacteristic = gatt.mtuSizeCharacteristic {
            cbPeripheralRef?.setNotifyValue(true, for: mtuSizeCharacteristic)
        }

        // Enable notifications for supervision timeout characteristic
        if let supervisionTimeoutCharacteristic = gatt.supervisionTimeoutCharacteristic {
            cbPeripheralRef?.setNotifyValue(true, for: supervisionTimeoutCharacteristic)
        }
    }
}

extension BGM220P: CBPeripheralDelegate {
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: (any Error)?) {
        // Need to discover characteristics for each service
        if let services = peripheral.services {
            for service in services {
                if gatt.foundService(service: service) {
                    print("Assigned service")
                }
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: (any Error)?) {
        // Need to discover descriptors for each characteristic
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                if gatt.foundCharacteristic(characteristic: characteristic){
                    print("Assigned characteristic")
                }
                peripheral.discoverDescriptors(for: characteristic)
            }
        }

        // Check if all characteristics have been found
        if gatt.allCharacteristicsFound() {
            print("All characteristics found")
            // Enable notifications
            enableNotifications()
            readThroughputInformation()
        }
        
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: (any Error)?) {
        // Do nothing
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: (any Error)?) {
        
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: (any Error)?) {
        print("Updated value for descriptor with UUID: \(descriptor.uuid)")
    }

    public func peripheral(_ peripheral: CBPeripheral, didDiscoverIncludedServicesFor service: CBService, error: (any Error)?) {
        
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: (any Error)?) {
        // Log out the characteristic that has been updated
        print("Updated notification state for characteristic with UUID: \(characteristic.uuid), Notifications Enabled: \(characteristic.isNotifying)")
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: (any Error)?) {
         
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: (any Error)?) {
        // Attempt to decode the data
        if let data: Data = characteristic.value {
            let value = decode(data: data, characterisitc: characteristic.uuid)
            print("Value: \(value)")
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: (any Error)?) {
        
    }
    
    public func peripheralIsReady(toSendWriteWithoutResponse peripheral: CBPeripheral) {
         
    }
}

extension BGM220P {
      func decode(data: Data, characterisitc: CBUUID) -> ConnectionParameter {
        switch characterisitc {
        case CBUUID.connectionPhyCharacteristicUUID:
            phy = decodePHY(data: data)
            return .phy(phy: decodePHY(data: data))
            
        case CBUUID.connectionIntervalCharacteristicUUID:
            connectionInterval = decodeConnectionInterval(data: data)
            return .connectionInterval(value: decodeConnectionInterval(data: data))
            
        case CBUUID.responderLatencyCharacteristicUUID:
            slaveLatency = decodeSlaveLatency(data: data)
            return .slaveLatency(value: decodeSlaveLatency(data: data))
            
        case CBUUID.supervisionTimeoutCharacteristicUUID:
            supervisionTimeout = decodeSupervisionTimeout(data: data)
            return .supervisionTimeout(value: decodeSupervisionTimeout(data: data))
            
        case CBUUID.pduSizeCharacteristicUUID:
            pduSize = decodePDU(data: data)
            return .pdu(value: decodePDU(data: data))
            
        case CBUUID.mtuSizeCharacteristicUUID:
            mtuSize = decodeMTU(data: data)
            return .mtu(value: decodeMTU(data: data))
        
        case CBUUID.transmissionOnCharacteristicUUID:
            print("Transmission On Data: \(data.hexDescription)")
            // If the data is == 0x01, then the transmission is on and set start time stamp
            if data.integerValueFromData() == 0x01 {
                // Reset bytes received
                bytesReceived = 0
                startTimeStam = Date()
                testActive = true
            } else if data.integerValueFromData() == 0x00 {
                // If the data is == 0x00, then the transmission is off and set stop time stamp
                stopTimeStamp = Date()
                testActive = false
                // Calculate throughput
                if let startTime = startTimeStam, let stopTime = stopTimeStamp {
                    let timeInterval = stopTime.timeIntervalSince(startTime)
                    let bitsReceived = Double(bytesReceived) * 8.0
                    throughput = Int((Double(bitsReceived) / timeInterval) / 1000)
                    print("Throughput: \(throughput)")
                }
            }
            return .unknown
        
        case CBUUID.notificationsCharacteristicUUID:
            // Add size of data to bytes received
            bytesReceived += data.count
            guard let startTimeStam else { return .unknown }
            elapsedTime = Int(Date().timeIntervalSince(startTimeStam))
            return .unknown
            
        case CBUUID.indicationsCharacteristicUUID:
            print("I")
            return .unknown
        
        case CBUUID.throughputResultCharacteristicUUID:
            return .unknown
            
        default:
            return .unknown
        }
    }
    
    private func decodePHY(data: Data) -> PHY {
        let value = data.integerValueFromData()
        
        switch value {
        case 0x01:
            return ._1M
            
        case 0x02:
            return ._2M
            
        case 0x04:
            return ._125k
            
        case 0x08:
            return ._500k
            
        default:
            return ._unknown
        }
    }
    
    private func decodeConnectionInterval(data: Data) -> Int {
        let value = data.integerValueFromData()
        return Int(Double(value) * 1.25)
    }
    
    private func decodeSlaveLatency(data: Data) -> Int {
        let value = data.integerValueFromData()
        return Int(Double(value) * 1.25)
    }
    
    private func decodeSupervisionTimeout(data: Data) -> Int {
        let value = data.integerValueFromData()
        return Int(Double(value) * 10.0)
    }
    
    private func decodePDU(data: Data) -> Int {
        let value = data.integerValueFromData()
        
        if value > 255 {
            return -1
        }
        
        return value
    }
    
    private func decodeMTU(data: Data) -> Int {
        let value = data.integerValueFromData()
        
        if value > 255 {
            return -1
        }
        
        return value
    }
}

enum PHY: String {
    case _1M = "1M"
    case _2M = "2M"
    case _125k = "Coded 125k"
    case _500k = "Coded 500k"
    case _unknown = "N/A"
}

enum ConnectionParameter {
    case phy(phy: PHY)
    case connectionInterval(value: Int)
    case slaveLatency(value: Int)
    case supervisionTimeout(value: Int)
    case pdu(value: Int)
    case mtu(value: Int)
    case unknown
}

protocol SILThroughputConnectionParametersDecoderType {
    func decode(data: Data, characterisitc: CBUUID) -> ConnectionParameter
}



struct SILThroughputConnectionParametersDecoder {
    func decode(data: Data, characterisitc: CBUUID) -> ConnectionParameter {
        switch characterisitc {
        case CBUUID.connectionPhyCharacteristicUUID:
            return .phy(phy: decodePHY(data: data))
            
        case CBUUID.connectionIntervalCharacteristicUUID:
            return .connectionInterval(value: decodeConnectionInterval(data: data))
            
        case CBUUID.responderLatencyCharacteristicUUID:
            return .slaveLatency(value: decodeSlaveLatency(data: data))
            
        case CBUUID.supervisionTimeoutCharacteristicUUID:
            return .supervisionTimeout(value: decodeSupervisionTimeout(data: data))
            
        case CBUUID.pduSizeCharacteristicUUID:
            return .pdu(value: decodePDU(data: data))
            
        case CBUUID.mtuSizeCharacteristicUUID:
            return .mtu(value: decodeMTU(data: data))
            
        default:
            return .unknown
        }
    }
    
    private func decodePHY(data: Data) -> PHY {
        let value = data.integerValueFromData()
        
        switch value {
        case 0x01:
            return ._1M
            
        case 0x02:
            return ._2M
            
        case 0x04:
            return ._125k
            
        case 0x08:
            return ._500k
            
        default:
            return ._unknown
        }
    }
    
    private func decodeConnectionInterval(data: Data) -> Int {
        let value = data.integerValueFromData()
        return Int(Double(value) * 1.25)
    }
    
    private func decodeSlaveLatency(data: Data) -> Int {
        let value = data.integerValueFromData()
        return Int(Double(value) * 1.25)
    }
    
    private func decodeSupervisionTimeout(data: Data) -> Int {
        let value = data.integerValueFromData()
        return Int(Double(value) * 10.0)
    }
    
    private func decodePDU(data: Data) -> Int {
        let value = data.integerValueFromData()
        
        if value > 255 {
            return -1
        }
        
        return value
    }
    
    private func decodeMTU(data: Data) -> Int {
        let value = data.integerValueFromData()
        
        if value > 255 {
            return -1
        }
        
        return value
    }
}


extension Data {

    
    func integerValueFromData() -> Int {
        let dataArray = convertData(data: self)
        let value = integerFromBytesArray(bytesArray: dataArray)
        
        return value
    }
    
    var hexDescription: String {
        return reduce("") {$0 + String(format: "%02x", $1)}
    }
    
    fileprivate func convertData(data: Data) -> [UInt8] {
        return [UInt8](data)
    }
    
    fileprivate func integerFromBytesArray(bytesArray: [UInt8]) -> Int {
        var value = 0
        for (i, byteValue) in bytesArray.enumerated() {
            let shiftValue = pow(2.0, i * 8)
            let shiftValueInt = (shiftValue as NSDecimalNumber).intValue
            value += (Int(byteValue) * shiftValueInt)
        }
        return value
    }
}
