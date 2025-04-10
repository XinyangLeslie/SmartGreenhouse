import SwiftUI
import Charts

struct LightBarChartView: View {
    @ObservedObject var viewModel: ChartViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Recent Light Levels")
                .font(.headline)
                .padding(.bottom, 5)

            Chart {
                ForEach(viewModel.chartData) { data in
                    BarMark(
                        x: .value("Time", data.label),
                        y: .value("Lux", data.value)
                    )
                    .foregroundStyle(.yellow)
                }
            }
            .frame(height: 250)
            .padding(.horizontal)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(12)
    }
}

