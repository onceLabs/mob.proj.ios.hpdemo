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
        VStack{
            ProgressView()
                .scaleEffect(2)
                .padding(.bottom, 50)
            VStack{
                Button {
                    if (isScanning){
                        vm.stopScan()
                    } else {
                        vm.startScan()
                    }
                    isScanning = !isScanning
                } label: {
                    Text(isScanning ? "Stop Scan" : "Start Scan")
                        .frame(maxWidth: .infinity)
                }
                .padding(10)
                .foregroundColor(.white)
                .background(.blue)
                .cornerRadius(5)
                
                Button {

                } label: {
                    Text("Begin Test")
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
            
            Picker("TX Method", selection: $txMethod){
                Text("Notifications").tag(TXMethod.Notifications)
                Text("Indications").tag(TXMethod.Indications)
            }
            .pickerStyle(.segmented)
            .padding(
                EdgeInsets(
                    top: 20,
                    leading: 50,
                    bottom: 0,
                    trailing: 50))
            Text("Transmit Method: \(txMethod)")
            
            VStack{
                HStack{
                    Text("Connection Interval: ")
                    Spacer()
                    Text("30ms")
                }
                HStack{
                    Text("PHY: ")
                    Spacer()
                    Text("2M")
                }
                HStack{
                    Text("MTU: ")
                    Spacer()
                    Text("247")
                }
                HStack{
                    
                }
            }
            .padding(
                EdgeInsets(
                    top: 20,
                    leading: 50,
                    bottom: 20,
                    trailing: 50))
            
            VStack{
                HStack{
                    Text("Bytes Sent:")
                    Spacer()
                    Text("12,394")
                }
                HStack{
                    Text("Elapsed Time:")
                    Spacer()
                    Text("12.34 Seconds")
                }
                HStack{
                    Text("Avg Throughput:")
                    Spacer()
                    Text("328kbps")
                }
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
