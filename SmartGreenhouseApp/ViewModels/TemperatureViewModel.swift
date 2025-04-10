//
//  TemperatureViewModel.swift
//
//

import Foundation

class TemperatureViewModel: ObservableObject {
    @Published var latestTemperature: String = "--°C"
    @Published var latestHumidity: String = "--%"

    func fetchLatestTemperature(userID: String) {
        // 👇 拼接带 user_id 的 API 地址
        let apiURL = "http://\(Config.serverIP):5001/api/temperature?user_id=\(userID)"
        
        guard let url = URL(string: apiURL) else {
            print("❌ API URL 无效")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ 请求失败: \(error.localizedDescription)")
                return
            }

            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(TemperatureResponse.self, from: data)
                    DispatchQueue.main.async {
                        if let latestData = decodedData.data.first {
                            self.latestTemperature = "\(latestData.temperature)°C"
                            self.latestHumidity = "\(latestData.humidity)%"
                        }
                    }
                } catch {
                    print("❌ JSON 解析失败: \(error)")
                }
            }
        }.resume()
    }
}
