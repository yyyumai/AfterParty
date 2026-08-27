import Charts
import SwiftUI

struct MetricChart: View {
    let metrics: [HealthMetric]
    let session: DrinkingSession

    var body: some View {
        Chart {
            ForEach(metrics) { metric in
                LineMark(
                    x: .value("Time", metric.timestamp),
                    y: .value(metric.kind.fullTitle, metric.value)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(metric.kind.tint)

                AreaMark(
                    x: .value("Time", metric.timestamp),
                    y: .value(metric.kind.fullTitle, metric.value)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(metric.kind.tint.opacity(0.16))
            }

            RuleMark(x: .value("Event", session.startDate))
                .foregroundStyle(.white.opacity(0.55))
                .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                .annotation(position: .top, alignment: .leading) {
                    Text("EVENT")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(.secondary)
                }
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .hour, count: 2)) { _ in
                AxisGridLine().foregroundStyle(.white.opacity(0.08))
                AxisTick().foregroundStyle(.white.opacity(0.16))
                AxisValueLabel(format: .dateTime.hour())
                    .foregroundStyle(.secondary)
            }
        }
        .chartYAxis {
            AxisMarks { _ in
                AxisGridLine().foregroundStyle(.white.opacity(0.08))
                AxisTick().foregroundStyle(.white.opacity(0.16))
                AxisValueLabel().foregroundStyle(.secondary)
            }
        }
        .frame(height: 260)
        .padding(16)
        .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}
