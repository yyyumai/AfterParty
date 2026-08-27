import Foundation

@MainActor
final class AnalysisViewModel: ObservableObject {
    @Published var comparisons: [MetricComparison] = []
    @Published var selectedMetric: HealthMetricKind = .heartRate
    @Published var timeline: [HealthMetric] = []
    @Published var analysis: AIAnalysis = .placeholder
    @Published var userAnalysis: UserAnalysis = .placeholder
    @Published var isLoading = false

    private let healthService: HealthDataService
    private let aiService: AIAnalysisService
    private let userAnalysisService: UserAnalysisService

    init(
        healthService: HealthDataService = MockHealthDataService(),
        aiService: AIAnalysisService = MockAIAnalysisService(),
        userAnalysisService: UserAnalysisService = MockUserAnalysisService()
    ) {
        self.healthService = healthService
        self.aiService = aiService
        self.userAnalysisService = userAnalysisService
    }

    func load(session: DrinkingSession, recentSessions: [DrinkingSession]) async {
        isLoading = true
        defer { isLoading = false }

        do {
            let baseline = try await healthService.fetchBaseline(before: session.startDate)
            let metrics = try await healthService.fetchMetrics(from: session.startDate, to: session.endDate)
            comparisons = HealthMetricKind.allCases.compactMap { kind in
                guard let metric = metrics.first(where: { $0.kind == kind }) else { return nil }
                return MetricComparison(kind: kind, baselineValue: baseline.value(for: kind), sessionValue: metric.value)
            }
            let recentSnapshots = try await makeSnapshots(for: recentSessions)
            timeline = try await healthService.fetchTimeline(for: selectedMetric, session: session)
            analysis = try await aiService.generateAnalysis(
                for: session,
                comparisons: comparisons,
                recentSessions: recentSessions
            )
            userAnalysis = try await userAnalysisService.generateUserAnalysis(
                for: session,
                currentComparisons: comparisons,
                recentSnapshots: recentSnapshots
            )
        } catch {
            comparisons = []
            timeline = []
            analysis = AIAnalysis(
                summary: "Mock analysis could not be loaded.",
                observations: [],
                possibleContext: [],
                dataQuality: "Try opening the session again."
            )
            userAnalysis = UserAnalysis(
                responseLabel: "Unavailable",
                headline: "User analysis could not be loaded.",
                comparisonText: "Try opening the session again.",
                metricTraits: [],
                contextTraits: [],
                notes: []
            )
        }
    }

    func loadTimeline(session: DrinkingSession) async {
        do {
            timeline = try await healthService.fetchTimeline(for: selectedMetric, session: session)
        } catch {
            timeline = []
        }
    }

    func comparison(for kind: HealthMetricKind) -> MetricComparison? {
        comparisons.first { $0.kind == kind }
    }

    private func makeSnapshots(for sessions: [DrinkingSession]) async throws -> [SessionMetricSnapshot] {
        let healthService = self.healthService

        return try await withThrowingTaskGroup(of: SessionMetricSnapshot.self) { group in
            for session in sessions {
                group.addTask {
                    let baseline = try await healthService.fetchBaseline(before: session.startDate)
                    let metrics = try await healthService.fetchMetrics(from: session.startDate, to: session.endDate)
                    let comparisons = HealthMetricKind.allCases.compactMap { kind -> MetricComparison? in
                        guard let metric = metrics.first(where: { $0.kind == kind }) else { return nil }
                        return MetricComparison(kind: kind, baselineValue: baseline.value(for: kind), sessionValue: metric.value)
                    }

                    return SessionMetricSnapshot(
                        id: session.id,
                        sessionDate: session.startDate,
                        drinkCount: session.drinks.count,
                        tags: session.sortedTags,
                        comparisons: comparisons
                    )
                }
            }

            var snapshots: [SessionMetricSnapshot] = []
            for try await snapshot in group {
                snapshots.append(snapshot)
            }
            return snapshots.sorted { $0.sessionDate > $1.sessionDate }
        }
    }
}
