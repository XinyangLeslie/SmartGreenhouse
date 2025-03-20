//
//  LoginViewModel.swift
//  XinyangTestApp
//
//  Created by 张新杨 on 2025/2/13.
//

import SwiftUI
import Combine

class LoginViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var loginError: String? = nil // 额外添加错误信息状态

    func login(username: String, password: String) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            DispatchQueue.main.async {
                if username == "admin" && password == "123456" {
                    self.currentUser = User(
                        id: UUID().uuidString,
                        username: username,
                        email: "\(username)@example.com",
                        phoneNumber: "1234567890",
                        isPhoneVerified: true,
                        verificationCode: nil,
                        role: .member,
                        createdAt: "2025-02-13",
                        ownedDevices: [],
                        avatarUrl: nil
                    )
                    self.loginError = nil // 登录成功，清除错误信息
                } else {
                    self.currentUser = nil
                    self.loginError = "用户名或密码错误"
                }
            }
        }
    }
}
