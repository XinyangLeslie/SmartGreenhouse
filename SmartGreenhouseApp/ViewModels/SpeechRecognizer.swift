//
//  SpeechRecognizer.swift
//  XinyangTestApp
//
//  Created by 张新杨 on 2025/3/17.
//

import Foundation
import Speech
import AVFoundation

class SpeechRecognizer: ObservableObject {
    @Published var recognizedText: String = ""  // 存储识别的文本

    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "zh-CN"))  // 设置为中文
    private let audioEngine = AVAudioEngine()
    private let request = SFSpeechAudioBufferRecognitionRequest()
    private var recognitionTask: SFSpeechRecognitionTask?

    init() {
        requestAuthorization()  // 申请权限
    }

    

    func requestMicrophonePermission() {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            if granted {
                print("✅ 麦克风权限已授权")
            } else {
                print("❌ 用户拒绝了麦克风权限")
            }
        }
    }

    
    /// 申请语音识别权限
    private func requestAuthorization() {
        SFSpeechRecognizer.requestAuthorization { status in
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    print("✅ 语音识别权限已授权")
                case .denied, .restricted, .notDetermined:
                    print("❌ 语音识别权限被拒绝或未设置")
                @unknown default:
                    fatalError()
                }
            }
        }
    }

    /// 开始语音识别
    func startListening() {
        do {
            let inputNode = audioEngine.inputNode
            let recognitionFormat = inputNode.outputFormat(forBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recognitionFormat) { (buffer, _) in
                self.request.append(buffer)
            }
            
            audioEngine.prepare()
            try audioEngine.start()
            
            recognitionTask = speechRecognizer?.recognitionTask(with: request) { result, error in
                if let result = result {
                    DispatchQueue.main.async {
                        self.recognizedText = result.bestTranscription.formattedString
                        print("🎙️ 识别到文本: \(self.recognizedText)")
                    }
                }
                if error != nil {
                    self.stopListening()
                }
            }
        } catch {
            print("❌ 语音识别启动失败: \(error.localizedDescription)")
        }
    }

    /// 停止语音识别
    func stopListening() {
        audioEngine.stop()
        recognitionTask?.cancel()
        recognitionTask = nil
        print("🛑 语音识别已停止")
    }
}
