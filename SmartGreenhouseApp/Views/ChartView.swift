//
//  ChartView.swift
//
//
import SwiftUI
import Charts

struct ChartView: View {
    
    var userID: String
    
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
            viewModel.userID = userID // 👈 设置 userID
            viewModel.fetchChartData() // ✅ 页面加载时获取数据
        }
    }
}

