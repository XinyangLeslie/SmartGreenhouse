//
//  FullScreenCameraView.swift
//
//

import SwiftUI

struct FullScreenCameraView: View {
    let streamURL: String
    @Binding var isFullScreen: Bool // ✅ 绑定主界面变量

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea() // ✅ 全屏背景黑色

            CameraViewModel(urlString: streamURL) // ✅ 显示直播流
                .edgesIgnoringSafeArea(.all)

            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        isFullScreen = false // ✅ 退出全屏
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                Spacer()
            }
        }
        .onAppear {
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation") // ✅ 横屏模式
        }
        .onDisappear {
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation") // ✅ 退出恢复竖屏
        }
    }
}
