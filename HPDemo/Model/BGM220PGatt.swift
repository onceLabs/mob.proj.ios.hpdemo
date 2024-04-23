//
//  BGM220PGatt.swift
//  HPDemo
//
//  Created by Joe Bakalor on 4/16/24.
//

import Foundation
import CoreBluetooth

struct BGM220PGatt {
    var throughputService: CBService?
    var indicationsCharacteristic: CBCharacteristic?
    var notificationsCharacteristic: CBCharacteristic?
    var transmissionOnCharacteristic: CBCharacteristic?
    var throughputResultCharacteristic: CBCharacteristic?

    var throughputInformationService: CBService?
    var connectionPhyCharacteristic: CBCharacteristic?
    var connectionIntervalCharacteristic: CBCharacteristic?
    var responderLatencyCharacteristic: CBCharacteristic?
    var supervisionTimeoutCharacteristic: CBCharacteristic?
    var pduSizeCharacteristic: CBCharacteristic?
    var mtuSizeCharacteristic: CBCharacteristic?

    
    mutating func foundCharacteristic(characteristic: CBCharacteristic) -> Bool {
        switch characteristic.uuid {
        case CBUUID.indicationsCharacteristicUUID:
            indicationsCharacteristic = characteristic
            print("Found indications characteristic")
            return true
        case CBUUID.notificationsCharacteristicUUID:
            notificationsCharacteristic = characteristic
            print("Found notifications characteristic")
            return true
        case CBUUID.transmissionOnCharacteristicUUID:
            transmissionOnCharacteristic = characteristic
            print("Found transmission on characteristic")
            return true
        case CBUUID.throughputResultCharacteristicUUID:
            throughputResultCharacteristic = characteristic
            print("Found throughput result characteristic")
            return true
        case CBUUID.connectionPhyCharacteristicUUID:
            connectionPhyCharacteristic = characteristic
            print("Found connection phy characteristic")
            return true
        case CBUUID.connectionIntervalCharacteristicUUID:
            connectionIntervalCharacteristic = characteristic
            print("Found connection interval characteristic")
            return true
        case CBUUID.responderLatencyCharacteristicUUID:
            responderLatencyCharacteristic = characteristic
            print("Found responder latency characteristic")
            return true
        case CBUUID.supervisionTimeoutCharacteristicUUID:
            supervisionTimeoutCharacteristic = characteristic
            print("Found supervision timeout characteristic")
            return true
        case CBUUID.pduSizeCharacteristicUUID:
            pduSizeCharacteristic = characteristic
            print("Found pdu size characteristic")
            return true
        case CBUUID.mtuSizeCharacteristicUUID:
            mtuSizeCharacteristic = characteristic
            print("Found mtu size characteristic")
            return true
        default:
            return false
        }
    }

    mutating func foundService(service: CBService) -> Bool {
        switch service.uuid {
        case CBUUID.throughputTestServiceUUID:
            throughputService = service
            print("Found throughput test service")
            return true
        case CBUUID.throughputInformationServiceUUID:
            throughputInformationService = service
            print("Found throughput information service")
            return true
        default:
            return false
        }
    }

    func allCharacteristicsFound() -> Bool {
        return indicationsCharacteristic != nil &&
            notificationsCharacteristic != nil &&
            transmissionOnCharacteristic != nil &&
            throughputResultCharacteristic != nil &&
            connectionPhyCharacteristic != nil &&
            connectionIntervalCharacteristic != nil &&
            responderLatencyCharacteristic != nil &&
            pduSizeCharacteristic != nil &&
            mtuSizeCharacteristic != nil
    }
}

