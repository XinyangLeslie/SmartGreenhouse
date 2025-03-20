//
//  ContentView.swift
//  XinyangTestApp
//
//  Created by 张新杨 on 2024/6/16.
//

import SwiftUI

struct ContentView: View {
    
    @State private var ipAddress: String = "获取中..."
    @State private var bluetoothStatus: String = "未检查"

    
    var body: some View {
        NavigationView {
                    NavigationLink(destination: DetailView(message: "Hello, Detail Page!")) {
                        Text("Go to Detail Page")
                    }
                }
        VStack {
                    Text("设备 IP 地址: \(ipAddress)")
                        .padding()
                    Text("蓝牙状态: \(bluetoothStatus)")
                        .padding()
                    Button("检查蓝牙权限") {
                        let bluetoothManager = BluetoothManager()
                        bluetoothStatus = "检查中，请查看日志"
                    }
                    .padding()
                    Button("获取 IP 地址") {
                        if let ip = NetworkManager.getIPAddress() {
                            ipAddress = ip
                        } else {
                            ipAddress = "无法获取 IP 地址"
                        }
                    }
                    .padding()
                }
                .onAppear {
                    if let ip = NetworkManager.getIPAddress() {
                        ipAddress = ip
                    }
                }
            }
        }


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
