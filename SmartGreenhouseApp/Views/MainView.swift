//
//  MainView.swift
//
//

import SwiftUI
import WebKit

//主结构体
struct MainView: View {
    var user: User
    @State private var selectedTab = 0
    @StateObject private var notifyVM = NotificationViewModel()

    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    if selectedTab == 0 {
                        DashboardView(userID: user.id)
                    } else if selectedTab == 1 {
                        ControlPanelView()
                    } else if selectedTab == 2 {
                        CameraView()
                    } else if selectedTab == 3 {
                        HomeView()
                    }

                    CustomTabBar(selectedTab: $selectedTab)
                        .background(Color(.clear))
                }
                .background(
                    Image("background3")
                        .resizable()
                        .scaledToFill()
                        .blur(radius: 8)
                        .ignoresSafeArea()
                )
            }

            // ✅ 顶部弹出提示
            if notifyVM.showBanner {
                TopBannerView(message: notifyVM.notificationMessage)
                    .transition(.move(edge: .top))
                    .zIndex(1000) // 放在最上层
            }
        }
        .onAppear {
            notifyVM.startPollingNotifications()
        }
        .onDisappear {
            notifyVM.stopPolling()
        }
    }
}


// 首页按钮部分
struct QuickButtonView: View {
    var body: some View {
        VStack{
            HStack(spacing: 16) { // 按钮间隔
                QuickButton(icon: "sun.max.fill", title: "Good morning", backgroundColor: Color.white.opacity(0.2))
                QuickButton(icon: "moon.fill", title: "Good night", backgroundColor: Color.white.opacity(0.2))
            }
            .padding()
            
            HStack(spacing: 16) { // 按钮间隔
                QuickButton(icon: "sun.max.fill", title: "Good morning", backgroundColor: Color.white.opacity(0.2))
                QuickButton(icon: "moon.fill", title: "Good night", backgroundColor: Color.white.opacity(0.2))
            }
            .padding()
        }
        
    }
}

// 单个按钮组件
struct QuickButton: View {
    var icon: String
    var title: String
    var backgroundColor: Color

    var body: some View {
        Button(action: {
            print("\(title) button tapped")
        }) {
            HStack {
                Image(systemName: icon) // 图标
                    .foregroundColor(.yellow)
                    .font(.title2)

                Text(title) // 文字
                    .font(.headline)
                    .foregroundColor(.white)

                Spacer()

                Image(systemName: "play.fill") // 播放按钮
                    .foregroundColor(.white)
                    .font(.title2)
            }
            .padding()
            .frame(width: 160, height: 70) // 固定尺寸
            .background(backgroundColor)
            .cornerRadius(16) // 圆角
            .shadow(radius: 3) // 阴影
        }
    }
}
// 首页仪表盘界面
struct DashboardView: View {
    var userID: String // 接收 userID
    @StateObject private var viewModel = TemperatureViewModel() // 绑定 ViewModel
    @StateObject var lightVM = LightViewModel()
    
    @StateObject var chartVM = ChartViewModel()

    
    var body: some View {
        
        ScrollView{
            // 仪表盘布局
            VStack(spacing:4) {
                Text("Smart Farm Dashboard")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(Color.white)
                HStack {
                    SensorCard(title: "Temperature", value: viewModel.latestTemperature, icon: "thermometer")
                    SensorCard(title: "Humidity", value: viewModel.latestHumidity, icon: "drop.fill")
                }
                HStack {
                    SensorCard(title: "Light", value: lightVM.latestLight, icon: "sun.max.fill")
                    SensorCard(title: "Soil humidity", value: "40%", icon: "leaf.fill")
                }
                
                
                ChartView(userID: userID)
                
                // 柱状图：光照对比
                LightBarChartView(viewModel: chartVM)
                QuickButtonView()
            }
            .cornerRadius(20)
            // 设置宽度为屏幕宽度的96%
            .frame(width: UIScreen.main.bounds.width * 0.92)
        }.onAppear {
            print("当前账户ID: \(userID)")
            viewModel.fetchLatestTemperature(userID: userID) // ✅ 页面加载时获取最新温度
            lightVM.fetchLatestLight(userID: userID) // ✅ 页面加载时获取最新光照
            
            chartVM.selectedChart = 2  // 2 是 light 对应的 chart index
            chartVM.userID = userID
            chartVM.fetchChartData()

        }
        
    }
}






// 设备控制界面
struct ControlPanelView: View {
    @StateObject private var viewModel = ButtonViewModel()

    var body: some View {
        ScrollView {
            VStack {
                Text("Device Control")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)

                ToggleView(title: "Water Pump", isOn: $viewModel.isWaterPumpOn, onToggle: { newValue in
                    viewModel.toggleDevice(device: "servo", isOn: newValue)
                })

                ToggleView(title: "Fan", isOn: $viewModel.isFanOn, onToggle: { newValue in
                    viewModel.toggleDevice(device: "fan", isOn: newValue)
                })

                ToggleView(title: "LED Light", isOn: $viewModel.isLedOn, onToggle: { newValue in
                    viewModel.toggleDevice(device: "led", isOn: newValue)
                })
                ToggleView(title: "Buzzer", isOn: $viewModel.isBuzzerOn, onToggle: { newValue in
                    viewModel.toggleDevice(device: "buzzer", isOn: newValue)
                })
            }
            .padding()
        }
        .onAppear {
            viewModel.fetchDeviceStates()
        }
    }
}


struct ToggleView: View {
    let title: String
    @Binding var isOn: Bool
    var onToggle: (Bool) -> Void  // ✅ 确保 ToggleView 支持 onToggle 传参

    var body: some View {
        Toggle(isOn: $isOn) {
            Text(title)
                .foregroundColor(.white)
                .bold()
        }
        .padding()
        .background(isOn ? Color.green.opacity(0.7) : Color.gray.opacity(0.4))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white, lineWidth: 2)
        )
        .padding(.horizontal, 20)
        .onChange(of: isOn) { newValue in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                onToggle(newValue)  // ✅ 确保传递新状态
            }
        }
    }
}




// 个人主页

struct HomeView: View {
    var body: some View {
        ScrollView{
            VStack {
                Text("Home")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(Color.white)
                
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 300, height: 200)
                    .overlay(
                        Text("Camera Stream Here")
                    )
            }
        }
    }
}
// 底部导航栏
struct CustomTabBar: View {
    @Binding var selectedTab: Int

    var body: some View {
        HStack {
            Spacer()
            Button(action: { selectedTab = 0 }) {
                VStack {
                    Image(systemName: "chart.bar.fill")
                    Text("Dashboard")
                }.foregroundColor(selectedTab == 0 ? .white : .white.opacity(0.5))
            }
            Spacer()
            Button(action: { selectedTab = 1 }) {
                VStack {
                    Image(systemName: "switch.2")
                    Text("Control")
                }.foregroundColor(selectedTab == 1 ? .white : .white.opacity(0.5))
            }
            Spacer()
            Button(action: { selectedTab = 2 }) {
                VStack {
                    Image(systemName: "video.fill")
                    Text("Camera")
                }.foregroundColor(selectedTab == 2 ? .white : .white.opacity(0.5))
            }
            Spacer()
            Button(action: { selectedTab = 3 }) {
                VStack {
                    Image(systemName: "person.fill")
                    Text("Home")
                }.foregroundColor(selectedTab == 3 ? .white : .white.opacity(0.5))
            }
            Spacer()
            
        }
        .padding()
        .background(Color.white.opacity(0.2))
        .cornerRadius(15)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}

// 传感器卡片组件
struct SensorCard: View {
    var title: String
    var value: String
    var icon: String

    var body: some View {
        HStack(spacing:5) {
            Image(systemName: icon)
                .font(.largeTitle)
                .foregroundColor(.blue)
            VStack{
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(value)
                    .font(.body)
                    .bold()
                    .foregroundColor(.white)
            }
        }
        .frame(minWidth: 150, maxWidth: .infinity, minHeight: 80, maxHeight: .infinity)
        .background(Color.black.opacity(0.2))
        .cornerRadius(16)
        .shadow(radius: 5)
        .padding(.horizontal,5)
        .padding(.vertical,5)
    }
}





// ✅ 统一的按钮组件
struct ChartButton: View {
    let icon: String
    let text: String
    let index: Int
    @ObservedObject var viewModel: ChartViewModel

    var body: some View {
        Button(action: {
            viewModel.selectedChart = index
            viewModel.fetchChartData()
        }) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(viewModel.selectedChart == index ? .blue : .white)
                Text(text)
                    .foregroundColor(viewModel.selectedChart == index ? .blue : .white)
                    .font(.caption)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .frame(width: 100, height: 60)
        .background(Color.white.opacity(0.2))
        .cornerRadius(8)
    }
}

// 预览
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(user: User(
            id: "user_123",
            username: "PreviewUser",
            email: "preview@example.com",
            phoneNumber: "0000000000",
            isPhoneVerified: true,
            verificationCode: nil,
            role: .admin,
            createdAt: "2025-01-01",
            ownedDevices: [],
            avatarUrl: nil
        ))
    }
}




