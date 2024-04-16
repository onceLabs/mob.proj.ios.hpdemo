//
//  BGM220P.swift
//  HPDemo
//
//  Created by Joe Bakalor on 4/16/24.
//

import Foundation
import CoreBluetooth

extension CBUUID {
    // Throughput Test Service
    static let throughputTestServiceUUID = CBUUID(string: "BBB99E70-FFF7-46CF-ABC7-2D32C71820F2")
    static let indicationsCharacteristicUUID = CBUUID(string: "6109B631-A643-4A51-83D2-2059700AD49F")
    static let notificationsCharacteristicUUID = CBUUID(string: "47B73DD6-DEE3-4DA1-9BE0-F5C539A9A4BE")
    static let transmissionOnCharacteristicUUID = CBUUID(string: "BE6B6BE1-CD8A-4106-9181-5FFE2BC67718")
    static let throughputResultCharacteristicUUID = CBUUID(string: "ADF32227-B00F-400C-9EEB-B903A6CC291B")
    
    // Throughput Information Service
    static let throughputInformationServiceUUID = CBUUID(string: "BA1E0E9F-4D81-BAE3-F748-3AD55DA38B46")
    static let connectionPhyCharacteristicUUID = CBUUID(string: "00A82B93-0FEB-2739-72BE-ABDA1F5993D0")
    static let connectionIntervalCharacteristicUUID = CBUUID(string: "0A32F5A6-0A6C-4954-F413-A698FAF2C664")
    static let responderLatencyCharacteristicUUID = CBUUID(string: "FF629B92-332B-E7F7-975F-0E535872DDAE")
    static let supervisionTimeoutCharacteristicUUID = CBUUID(string: "67E2C4F2-2F50-914C-A611-ADB3727B056D")
    static let pduSizeCharacteristicUUID = CBUUID(string: "30CC364A-0739-268C-4926-36F112631E0C")
    static let mtuSizeCharacteristicUUID = CBUUID(string: "3816DF2F-D974-D915-D26E-78300F25E86E")
}


protocol Peripheral {
    func didConnect()
    func didDisconnect()
}

open class BGM220P: NSObject, Peripheral {
    
    private var gatt: BGM220PGatt = BGM220PGatt()
    private var cbPeripheralRef: CBPeripheral?
    
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
    
    public func peripheralIsReady(toSendWriteWithoutResponse peripheral: CBPeripheral) {
         
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: (any Error)?) {
        // Log out the characteristic that has been updated
        print("Updated notification state for characteristic with UUID: \(characteristic.uuid), Notifications Enabled: \(characteristic.isNotifying)")
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: (any Error)?) {
         
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: (any Error)?) {
        
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: (any Error)?) {
        
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
    case connectionInterval(value: Double)
    case slaveLatency(value: Double)
    case supervisionTimeout(value: Double)
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
    
    private func decodeConnectionInterval(data: Data) -> Double {
        let value = data.integerValueFromData()
        return Double(value) * 1.25
    }
    
    private func decodeSlaveLatency(data: Data) -> Double {
        let value = data.integerValueFromData()
        return Double(value) * 1.25
    }
    
    private func decodeSupervisionTimeout(data: Data) -> Double {
        let value = data.integerValueFromData()
        return Double(value) * 10.0
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
