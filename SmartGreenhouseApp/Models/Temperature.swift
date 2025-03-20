//
//  Temperature.swift
//  XinyangTestApp
//
//  Created by 张新杨 on 2025/3/13.
//

import Foundation

// 解析 JSON 响应的外层结构
// 定义 API 响应的数据结构
struct TemperatureResponse: Codable {
    struct DataItem: Codable {
        let temperature: Float
        let humidity: Float
    }
    let data: [DataItem]
}

// 解析单个温度数据项
struct TemperatureData: Codable, Identifiable {
    var id: UUID { UUID() } // 生成唯一 ID
    let temperature: Double
    let created_at: String
}


