//
//  HomeViewModel.swift
//  HPDemo
//
//  Created by Joe Bakalor on 4/16/24.
//

import Foundation
import Factory

class HomeViewModel: ObservableObject {
    
    @Injected(Container.bleManager) private var bleManager
    
    func startScan(){
        bleManager.startScan()
    }
    
    func stopScan(){
        bleManager.stopScan()
    }
    
}
