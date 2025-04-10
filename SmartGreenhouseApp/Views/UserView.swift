//
//  UserView.swift
//
//
import SwiftUI

struct UserView: View {
    @StateObject private var viewModel = UserViewModel()

    var body: some View {
        NavigationView {
            VStack {
                if let errorMessage = viewModel.errorMessage {
                    Text("⚠️ \(errorMessage)")
                        .foregroundColor(.red)
                } else {
                    List(viewModel.users) { user in
                        VStack(alignment: .leading) {
                            Text("👤 用户名: \(user.username)")
                                .font(.headline)
                            Text("📧 邮箱: \(user.email)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle("用户列表")
            .onAppear {
                viewModel.fetchUsers()
            }
        }
    }
}

