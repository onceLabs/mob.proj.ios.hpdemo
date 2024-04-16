//
//  Container.swift
//  HPDemo
//
//  Created by Joe Bakalor on 4/16/24.
//

import Foundation
import Factory

extension Container {
    
    static let bleManager = Factory(scope: .singleton){
        BLEManager() as BLEManagerProviding
    }
    
}
