//
//  LightViewModel.swift
//
//

import Foundation

class LightViewModel: ObservableObject {
    @Published var latestLight: String = "-- Lux"

    func fetchLatestLight(userID: String) {
        // 👇 拼接带 user_id 的 API 地址
        let apiURL = "http://\(Config.serverIP):5001/api/light?user_id=\(userID)"
        
        guard let url = URL(string: apiURL) else {
            print("❌ Invalid API URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Request failed: \(error.localizedDescription)")
                return
            }

            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(LightResponse.self, from: data)
                    DispatchQueue.main.async {
                        if let latestData = decodedData.data.first {
                            self.latestLight = "\(latestData.light) Lux"
                            print(self.latestLight)
                        }
                    }
                } catch {
                    print("❌ JSON decoding failed: \(error)")
                }
            }
        }.resume()
    }
}

// MARK: - 数据结构模型
struct LightResponse: Codable {
    let success: Bool
    let data: [LightData]
}

struct LightData: Codable {
    let light: Float
    let created_at: String
}
