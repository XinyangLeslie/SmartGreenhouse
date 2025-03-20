//
//  ViewController.swift
//  XinyangTestApp
//
//  Created by 张新杨 on 2025/3/16.
//

import UIKit
import Speech  // 导入语音识别框架

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // **请求语音识别权限**
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                switch authStatus {
                case .authorized:
                    print("✅ 语音识别权限已启用")
                case .denied:
                    print("❌ 语音识别被拒绝")
                case .restricted:
                    print("⚠️ 语音识别受限")
                case .notDetermined:
                    print("❓ 尚未请求语音权限")
                @unknown default:
                    fatalError()
                }
            }
        }
    }
}
