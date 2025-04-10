import Foundation

// 用于 Chart 折线图、数据列表等显示的单项数据
struct TemperatureData: Codable, Identifiable {
    var id: UUID { UUID() } // 保证 SwiftUI ForEach 可用
    let temperature: Double
    let humidity: Int
    let created_at: String
    let device_id: String?
    let location: String?
}

// 外层 JSON 响应结构（你 API 返回的是 data: [...]）
struct TemperatureResponse: Codable {
    let data: [TemperatureData]
}


