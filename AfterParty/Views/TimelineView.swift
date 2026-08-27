import SwiftUI

struct TimelineView: View {
    @StateObject private var viewModel = AnalysisViewModel()
    let session: DrinkingSession

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Timeline")
                    .font(.largeTitle.weight(.bold))
                Text("Mock HealthKit-style data around the session window.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Picker("Metric", selection: $viewModel.selectedMetric) {
                    ForEach(HealthMetricKind.allCases) { kind in
                        Text(kind.title).tag(kind)
                    }
                }
                .pickerStyle(.segmented)

                MetricChart(metrics: viewModel.timeline, session: session)
            }
            .padding(20)
        }
        .background(Color(red: 0.04, green: 0.05, blue: 0.07).ignoresSafeArea())
        .task(id: session.id) {
            await viewModel.load(session: session, recentSessions: [])
        }
        .onChange(of: viewModel.selectedMetric) {
            Task {
                await viewModel.loadTimeline(session: session)
            }
        }
    }
}
