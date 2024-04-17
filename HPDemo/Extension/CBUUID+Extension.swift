//
//  CBUUID+Extension.swift
//  HPDemo
//
//  Created by Joe Bakalor on 4/17/24.
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
