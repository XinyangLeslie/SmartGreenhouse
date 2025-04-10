//
//  SpeechTestView.swift
//
//

import SwiftUI

struct SpeechTestView: View {
    @StateObject private var speechRecognizer = SpeechRecognizer()

    var body: some View {
        VStack {
            Text("🎙️ 语音测试")
                .font(.title)
                .bold()
                .padding()

            Text(speechRecognizer.recognizedText)
                .font(.headline)
                .padding()
                .frame(height: 100)
                .border(Color.gray, width: 1)

            Button(action: {
                speechRecognizer.startListening()
            }) {
                Label("🎙️ 开始识别", systemImage: "mic.fill")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()

            Button(action: {
                speechRecognizer.stopListening()
            }) {
                Label("🛑 停止识别", systemImage: "mic.slash.fill")
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
    }
}

