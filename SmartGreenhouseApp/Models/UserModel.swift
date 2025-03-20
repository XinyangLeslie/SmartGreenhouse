//
//  UserModel.swift
//  XinyangTestApp
//
//  Created by 张新杨 on 2025/3/1.
//
import Foundation

struct TestUser: Codable, Identifiable {
    let id: Int
    let username: String
    let email: String
}


