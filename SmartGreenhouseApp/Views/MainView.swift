
//
//  MainView.swift
//  XinyangTestApp
//
//  Created by 张新杨 on 2025/3/2.
//

import SwiftUI
import WebKit

// 主结构体
struct MainView: View {
    @State private var selectedTab = 0
    
    
    
    var body: some View {
        NavigationStack{
            VStack {
                if selectedTab == 0 {
                    DashboardView()
                } else if selectedTab == 1 {
                    ControlPanelView()
                } else if selectedTab == 2 {
                    CameraView()
                } else if selectedTab == 3 {
                    HomeView()
                }
                
                //Spacer()
                CustomTabBar(selectedTab: $selectedTab).background(Color(.clear))
            }.background(
                Image("background3")
                    .resizable()
                    .scaledToFill()
                    .blur(radius: 8)
                    .ignoresSafeArea()
            )
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
    @StateObject private var viewModel = TemperatureViewModel() // 绑定 ViewModel
    
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
                    SensorCard(title: "Light", value: "500 Lux", icon: "sun.max.fill")
                    SensorCard(title: "CO₂", value: "400 ppm", icon: "leaf.fill")
                }
                
                
                ChartView()
                QuickButtonView()
            }
            .cornerRadius(20)
            // 设置宽度为屏幕宽度的96%
            .frame(width: UIScreen.main.bounds.width * 0.92)
        }.onAppear {
            viewModel.fetchLatestTemperature() // ✅ 页面加载时获取最新温度
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


// 摄像头监控界面
struct CameraView: View {
    @State private var isFullScreen = false
    @State private var isPlayback = false
    private let streamURL = "http://\(Config.serverIP):8080/?action=stream"

    var body: some View {
        ScrollView {
            VStack {
                Text("Live Camera")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(Color.white)

                Button(action: {
                    isFullScreen.toggle()
                }) {
                    CameraViewModel(urlString: streamURL)
                        .frame(width: 300, height: 200)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .buttonStyle(PlainButtonStyle())

                Button(action: {
                    isPlayback.toggle()
                }) {
                    Text("View Past 1 Hour")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .sheet(isPresented: $isPlayback) {
                    VideoPlayerView()
                }
            }
        }
        .fullScreenCover(isPresented: $isFullScreen) {
            FullScreenCameraView(streamURL: streamURL, isFullScreen: $isFullScreen)
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


import Charts

struct ChartView: View {
    @StateObject private var viewModel = ChartViewModel()

    var body: some View {
        VStack(spacing: 4) {
            Text("ChartView")
                .font(.title3)
                .foregroundColor(.white)

            // 按钮组
            HStack(spacing: 1) {
                Spacer()
                ChartButton(icon: "chart.bar.fill", text: "Temperature", index: 0, viewModel: viewModel)
                Spacer()
                ChartButton(icon: "chart.pie.fill", text: "Humidity", index: 1, viewModel: viewModel)
                Spacer()
                ChartButton(icon: "waveform.path.ecg.rectangle.fill", text: "Light", index: 2, viewModel: viewModel)
                Spacer()
            }.padding(2)

            // ✅ 显示折线图，并修改坐标轴颜色
            Chart {
                ForEach(viewModel.chartData) { entry in
                    LineMark(
                        x: .value("Time", entry.label),
                        y: .value("Value", entry.value)
                    )
                    .foregroundStyle(.blue)  // ✅ 线条颜色
                    .symbol(.circle)
                }
            }
            .chartXAxis {
                AxisMarks {
                    AxisGridLine()
                        .foregroundStyle(.white.opacity(0.5)) // ✅ X轴网格线白色
                    AxisTick()
                        .foregroundStyle(.white) // ✅ X轴刻度白色
                    AxisValueLabel()
                        .foregroundStyle(.white) // ✅ X轴标签白色
                }
            }
            .chartYAxis {
                AxisMarks {
                    AxisGridLine()
                        .foregroundStyle(.white.opacity(0.5)) // ✅ Y轴网格线白色
                    AxisTick()
                        .foregroundStyle(.white) // ✅ Y轴刻度白色
                    AxisValueLabel()
                        .foregroundStyle(.white) // ✅ Y轴标签白色
                }
            }
            .frame(height: 200)
        }
        .padding()
        .background(Color.gray.opacity(0.3))
        .cornerRadius(16)
        .padding()
        .onAppear {
            viewModel.fetchChartData() // ✅ 页面加载时获取数据
        }
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
        MainView()
    }
}



