//
//  UserTestView.swift
//

import SwiftUI

struct UserHomeView: View {
    let user: User

    var body: some View {
        VStack(spacing: 16) {
            Text("欢迎 \(user.username)！")
                .font(.title)
            Text("邮箱: \(user.email)")
            Text("手机号: \(user.phoneNumber)")
            Text("角色: \(user.role.rawValue)")
            Text("设备: \(user.ownedDevices.joined(separator: ", "))")
        }
        .padding()
    }
}


