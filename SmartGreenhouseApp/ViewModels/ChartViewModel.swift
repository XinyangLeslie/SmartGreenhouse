//
//  ChartViewModel.swift
//  XinyangTestApp
//
//  Created by 张新杨 on 2025/3/16.
//

import Foundation

class ChartViewModel: ObservableObject {
    @Published var selectedChart: Int = 0
    @Published var chartData: [ChartData] = []

    private let baseURL = "http://\(Config.serverIP):5001"

    func fetchChartData() {
        var endpoint = ""
        switch selectedChart {
        case 0:
            endpoint = "/api/get-TempHum/temperature"
        case 1:
            endpoint = "/api/get-TempHum/humidity"
        case 2:
            endpoint = "/api/get-light"
        default:
            return
        }

        guard let url = URL(string: "\(baseURL)\(endpoint)") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ Error fetching data: \(error)")
                    return
                }

                guard let data = data else { return }

                do {
                    let result = try JSONDecoder().decode(SensorDataResponse.self, from: data)
                    // ✅ 确保数据按时间递增顺序排序
                    self.chartData = result.data.map {
                        let formattedTime = self.formatTimestamp($0.created_at)
                        return ChartData(label: formattedTime, value: $0.value)
                    }
                } catch {
                    print("❌ JSON Parsing error: \(error)")
                }
            }
        }.resume()
    }
    
    // ✅ 确保时间格式化为 "3/16 00:53"
    func formatTimestamp(_ timestamp: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds] // ✅ 适配 "T" 和 "Z"

        guard let date = isoFormatter.date(from: timestamp) else {
            print("⚠️ 时间解析失败: \(timestamp)")
            return timestamp
        }

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "HH:mm"
        outputFormatter.timeZone = TimeZone.current  // ✅ 转换为本地时间
        return outputFormatter.string(from: date)
    }

}

// ✅ API 响应结构
struct SensorDataResponse: Codable {
    let success: Bool
    let data: [SensorData]
}

struct SensorData: Codable {
    let created_at: String
    let value: Double
}

struct ChartData: Identifiable {
    let id = UUID()
    let label: String
    let value: Double
}
