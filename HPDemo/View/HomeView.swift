//
//  HomeView.swift
//  HPDemo
//
//  Created by Joe Bakalor on 4/16/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var vm = HomeViewModel()
    @State private var isScanning = false
    
    var body: some View {
        VStack{
            HStack{
                Button(isScanning ? "Stop Scan" : "Start Scan") {
                    if (isScanning){
                        vm.stopScan()
                    } else {
                        vm.startScan()
                    }
                    isScanning = !isScanning
                }
                .foregroundColor(.white)
                .padding(10)
                .background(.blue)
                .cornerRadius(5)
            }
        }
    }
}

#Preview {
    HomeView()
}
