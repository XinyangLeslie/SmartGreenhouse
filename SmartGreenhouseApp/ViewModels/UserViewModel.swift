//
//  UserViewModel.swift
//
//

import SwiftUI

class UserViewModel: ObservableObject {
    @Published var users: [TestUser] = []
    @Published var errorMessage: String?

    func fetchUsers() {
        guard let url = URL(string: "http://\(Config.serverIP):3306/api/users") else {
            errorMessage = "无效的 API 地址"
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "请求失败: \(error.localizedDescription)"
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "无数据返回"
                }
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(UserResponse.self, from: data)
                DispatchQueue.main.async {
                    if decodedResponse.success {
                        self.users = decodedResponse.data
                    } else {
                        self.errorMessage = "数据加载失败"
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "JSON 解析失败"
                }
            }
        }.resume()
    }
}

struct UserResponse: Codable {
    let success: Bool
    let data: [TestUser]
}

