//
//  HomeView.swift
//  HPDemo
//
//  Created by Joe Bakalor on 4/16/24.
//

import SwiftUI

enum TXMethod {
    case Notifications
    case Indications
}

struct HomeView: View {
    
    @StateObject private var vm = HomeViewModel()
    @State private var isScanning = false
    @State private var txMethod = TXMethod.Notifications
    
    
    var body: some View {
        let connectedDevice = vm.device
        VStack{
            if (vm.testActive){
                ProgressView()
                    .scaleEffect(2)
                    .padding(.bottom, 50)
            }
            VStack{
                Button {
                    if (isScanning){
                        vm.stopScan()
                    } else {
                        vm.startScan()
                    }
                    isScanning = !isScanning
                } label: {
                    Text(isScanning ? "Disconnect" : "Connect")
                        .frame(maxWidth: .infinity)
                }
                .padding(10)
                .foregroundColor(.white)
                .background(.blue)
                .cornerRadius(5)
            }
            .padding(
                EdgeInsets(
                    top: 10,
                    leading: 50,
                    bottom: 0,
                    trailing: 50))
            
            VStack{
                HStack{
                    Text("Connection Interval: ")
                    Spacer()
                    Text("\(connectedDevice?.connectionInterval ?? 30)")
                }.font(.title2)
                
                HStack{
                    Text("PHY: ")
                    Spacer()
                    Text("\(connectedDevice?.phy.rawValue ?? "2")")
                }.font(.title2)
                
                HStack{
                    Text("MTU: ")
                    Spacer()
                    Text("\(connectedDevice?.mtuSize ?? 247)")
                }.font(.title2)

            }
            .padding(
                EdgeInsets(
                    top: 20,
                    leading: 50,
                    bottom: 20,
                    trailing: 50))
            
            VStack{
                HStack{
                    Text("Bytes Received:")
                    Spacer()
                    Text("\(connectedDevice?.bytesReceived ?? 0)")
                }.font(.title2)
                
                HStack{
                    Text("Elapsed Time:")
                    Spacer()
                    Text("\(connectedDevice?.elapsedTime ?? 0) Seconds")
                }.font(.title2)
                
                HStack{
                    Text("Avg Throughput:")
                    Spacer()
                    Text("\(connectedDevice?.throughput ?? 0) kbps")
                }.font(.title2)
            }
            .padding(
                EdgeInsets(
                    top: 0,
                    leading: 50,
                    bottom: 50,
                    trailing: 50))
        }
    }
}

#Preview {
    HomeView()
}
