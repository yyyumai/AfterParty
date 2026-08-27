import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var comparisons: [MetricComparison] = []
    @Published var trendSummary = "Metric changes are based on your personal mock baseline."

    private let healthService: HealthDataService

    init(healthService: HealthDataService = MockHealthDataService()) {
        self.healthService = healthService
    }

    func loadLatestSummary(for session: DrinkingSession?) async {
        guard let session else {
            comparisons = []
            trendSummary = "Create a session to start comparing body metrics."
            return
        }

        do {
            let baseline = try await healthService.fetchBaseline(before: session.startDate)
            let metrics = try await healthService.fetchMetrics(from: session.startDate, to: session.endDate)
            comparisons = HealthMetricKind.allCases.compactMap { kind in
                guard let metric = metrics.first(where: { $0.kind == kind }) else { return nil }
                return MetricComparison(kind: kind, baselineValue: baseline.value(for: kind), sessionValue: metric.value)
            }

            let notable = comparisons.filter { abs($0.changePercent) >= 8 }.count
            trendSummary = notable >= 2
                ? "Several metrics moved away from your personal baseline."
                : "Recent changes are close to your mock baseline."
        } catch {
            comparisons = []
            trendSummary = "Unable to load mock metric summary."
        }
    }
}
