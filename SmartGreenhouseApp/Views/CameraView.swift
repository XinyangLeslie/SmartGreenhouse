import SwiftUI

func getReachableCameraIP() -> String {
    let ip1 = Config.cameraIP_1
    let ip2 = Config.cameraIP_2

    let testURL1 = URL(string: "http://\(ip1):8080/?action=stream")!
    let semaphore = DispatchSemaphore(value: 0)

    var selectedIP = ip2 // 默认值

    var request = URLRequest(url: testURL1)
    request.timeoutInterval = 1.5

    URLSession.shared.dataTask(with: request) { _, response, _ in
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
            selectedIP = ip1
        }
        semaphore.signal()
    }.resume()

    _ = semaphore.wait(timeout: .now() + 2.0)
    return selectedIP
}



// 摄像头监控界面
struct CameraView: View {
    @State private var isFullScreen = false
    @State private var isPlayback = false
    @State private var isGalleryOpen = false

    private let streamURL = "http://\(getReachableCameraIP()):8080/?action=stream"

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Live Camera")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(Color.white)

                // Live Stream
                Button(action: {
                    isFullScreen.toggle()
                }) {
                    CameraViewModel(urlString: streamURL)
                        .frame(width: 300, height: 200)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .buttonStyle(PlainButtonStyle())

                // Past Video Playback
//                Button(action: {
//                    isPlayback.toggle()
//                }) {
//                    Text("View Past 1 Hour")
//                        .font(.headline)
//                        .foregroundColor(.white)
//                        .padding()
//                        .background(Color.blue)
//                        .cornerRadius(10)
//                }
                

                // ➕ Image Gallery Button
                Button(action: {
                    isGalleryOpen.toggle()
                }) {
                    Text("Detection Images")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .sheet(isPresented: $isGalleryOpen) {
                    ImageGalleryView()
                }
            }
        }

    }
}
