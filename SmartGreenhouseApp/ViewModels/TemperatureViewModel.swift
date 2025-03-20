//
//  TemperatureViewModel.swift
//  XinyangTestApp
//
//  Created by 张新杨 on 2025/3/13.
//

import Foundation


class TemperatureViewModel: ObservableObject {
    @Published var latestTemperature: String = "--°C" // 默认值
    @Published var latestHumidity: String = "--%" // 默认湿度值

    let apiURL = "http://\(Config.serverIP):5001/api/temperature" // 修改为你的 API 地址

    func fetchLatestTemperature() {
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
                    print(data)
                    let decodedData = try JSONDecoder().decode(TemperatureResponse.self, from: data)
                    DispatchQueue.main.async {
                        if let latestData = decodedData.data.first {
                            self.latestTemperature = "\(latestData.temperature)°C" // ✅ 更新最新温度
                            self.latestHumidity = "\(latestData.humidity)%" // ✅ 更新湿度
                        }
                    }
                } catch {
                    print("❌ JSON 解析失败: \(error)")
                }
            }
        }.resume()
    }
}
