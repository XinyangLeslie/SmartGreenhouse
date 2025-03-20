//
//  LoginView.swift
//  XinyangTestApp
//
//  Created by 张新杨 on 2025/2/13.
//
import SwiftUI

struct LoginView: View {
    @StateObject private var loginVM = LoginViewModel()
    @State private var username = ""
    @State private var password = ""
    @State private var isPasswordVisible = false
    @State private var isLoggingIn = false

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Text("登录")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                TextField("请输入用户名", text: $username)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color.white.opacity(0.3))
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                    .foregroundColor(.white)

                HStack {
                    if isPasswordVisible {
                        TextField("请输入密码", text: $password)
                    } else {
                        SecureField("请输入密码", text: $password)
                    }

                    Button(action: {
                        isPasswordVisible.toggle()
                    }) {
                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                            .foregroundColor(.white)
                    }
                }
                .padding()
                .background(Color.white.opacity(0.3))
                .cornerRadius(10)
                .padding(.horizontal, 20)
                .foregroundColor(.white)

                Button(action: {
                    isLoggingIn = true
                    loginVM.login(username: username, password: password)
                }) {
                    Text("登录")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green.opacity(0.8))
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                }
                .disabled(isLoggingIn)

                if let errorMessage = loginVM.loginError {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }

                if loginVM.currentUser != nil {
                    Text("登录成功！欢迎 \(loginVM.currentUser!.username)")
                        .foregroundColor(.green)
                        .padding()
                }

                Spacer()
            }
            .padding(.top, 50)

            if isLoggingIn {
                Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                ProgressView("正在登录...")
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .font(.headline)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            isLoggingIn = false
                        }
                    }
            }
        }
    }
}

