
import Foundation
import Combine

class NotificationViewModel: ObservableObject {
    @Published var notificationMessage: String = ""
    @Published var showBanner: Bool = false
    
    private var lastTimestamp: Double = 0  // ✅ Last seen notification
    private var timer: Timer?

    func startPollingNotifications() {
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            self.fetchLatestNotification()
        }
    }

    func stopPolling() {
        timer?.invalidate()
        timer = nil
    }

    private func fetchLatestNotification() {
        guard let url = URL(string: "http://\(Config.serverIP):5001/api/latest-notification") else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }

            if let decoded = try? JSONDecoder().decode(NotificationResponse.self, from: data),
               let newNotification = decoded.data {
                
                // ✅ Only show if it's a new one
                if newNotification.timestamp > self.lastTimestamp {
                    self.lastTimestamp = newNotification.timestamp
                    
                    DispatchQueue.main.async {
                        self.notificationMessage = newNotification.message
                        self.showBanner = true

                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            self.showBanner = false
                        }
                    }
                }
            }
        }.resume()
    }
}


// MARK: - JSON Response Structure
struct NotificationResponse: Codable {
    let success: Bool
    let data: NotificationItem?
}

struct NotificationItem: Codable {
    let message: String
    let timestamp: Double
}
