import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var username: String = ""
    @State private var password: String = ""

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.green.opacity(0.6)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 25) {
                    Text("Welcome Back")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    VStack(spacing: 15) {
                        // 用户名输入框
                        TextField("Username", text: $username)
                            .padding()
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(10)
                            .autocapitalization(.none)

                        // 密码输入框
                        SecureField("Password", text: $password)
                            .padding()
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)

                    // 登录按钮
                    Button(action: {
                        viewModel.login(username: username, password: password)
                    }) {
                        Text("Login")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)

                    // 错误提示
                    if let error = viewModel.loginError {
                        Text(error)
                            .foregroundColor(.red)
                            .padding(.top, 10)
                    }

                    Spacer()

                    // 隐式导航跳转
                    NavigationLink(
                        destination: userHomeDestination(),
                        isActive: .constant(viewModel.isLoggedIn)
                    ) {
                        EmptyView()
                    }
                }
                .padding()
            }
        }
    }

    @ViewBuilder
    func userHomeDestination() -> some View {
        if let user = viewModel.currentUser {
            MainView(user: user)
        } else {
            Text("Loading user info…")
        }
    }
}
