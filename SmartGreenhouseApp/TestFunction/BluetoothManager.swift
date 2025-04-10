//
//  BluetoothManager.swift
//
//

import CoreBluetooth

class BluetoothManager: NSObject, CBCentralManagerDelegate {
    private var centralManager: CBCentralManager?

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("蓝牙已开启，可以进行操作")
        case .poweredOff:
            print("蓝牙已关闭，请打开蓝牙")
        case .unauthorized:
            print("蓝牙权限未授权")
        case .unsupported:
            print("设备不支持蓝牙功能")
        default:
            print("蓝牙状态未知")
        }
    }
}

