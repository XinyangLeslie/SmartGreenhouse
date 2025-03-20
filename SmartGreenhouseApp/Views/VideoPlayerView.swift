
//
//  VideoPlayerView.swift
//  XinyangTestApp
//
//  Created by 张新杨 on 2025/3/16.
//

import SwiftUI
import AVKit

struct VideoPlayerView: View {
    private let videoURL = URL(string: "http://\(Config.serverIP):5001/api/get-video")!

    var body: some View {
        VStack {
            Text("Playback Video")
                .font(.title)
                .foregroundColor(.white)

            VideoPlayer(player: AVPlayer(url: videoURL))
                .frame(height: 300)
                .cornerRadius(12)
                .shadow(radius: 5)
        }
        .padding()
        .background(Color.black.opacity(0.3))
        .cornerRadius(16)
        .padding()
    }
}
