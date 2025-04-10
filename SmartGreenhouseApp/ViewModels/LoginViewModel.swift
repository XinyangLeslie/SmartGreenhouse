import Foundation
import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var loginError: String? = nil

    // ✅ 顶部提示 Banner 状态
    @Published var bannerMessage: String = ""
    @Published var showBanner: Bool = false

    var isLoggedIn: Bool {
        return currentUser != nil
    }

    func login(username: String, password: String) {
        guard let url = URL(string: "http://\(Config.serverIP):5001/api/login") else {
            loginError = "❌ 无效的 API 地址"
            bannerMessage = loginError ?? "❌ 登录失败"
            showBanner = true
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let payload = [
            "username": username,
            "password": password
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload, options: [])
        } catch {
            loginError = "❌ 无法编码请求体"
            bannerMessage = loginError ?? "❌ 登录失败"
            showBanner = true
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.loginError = "❌ 网络请求失败：\(error.localizedDescription)"
                    self.bannerMessage = self.loginError ?? "❌ 登录失败"
                    self.showBanner = true
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self.loginError = "❌ 没有返回数据"
                    self.bannerMessage = self.loginError ?? "❌ 登录失败"
                    self.showBanner = true
                }
                return
            }

            do {
                let decoder = JSONDecoder()
                let user = try decoder.decode(User.self, from: data)
                DispatchQueue.main.async {
                    self.currentUser = user
                    self.loginError = nil
                    self.bannerMessage = "✅ 登录成功"
                    self.showBanner = true
                }
            } catch {
                DispatchQueue.main.async {
                    self.loginError = "❌ 登录失败：用户名或密码错误"
                    self.bannerMessage = self.loginError ?? "❌ 登录失败"
                    self.showBanner = true
                    print("解析失败：\(error)")
                }
            }

        }.resume()
    }
}
