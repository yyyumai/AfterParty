import Foundation

protocol UserAnalysisService: Sendable {
    func generateUserAnalysis(
        for session: DrinkingSession,
        currentComparisons: [MetricComparison],
        recentSnapshots: [SessionMetricSnapshot]
    ) async throws -> UserAnalysis
}
