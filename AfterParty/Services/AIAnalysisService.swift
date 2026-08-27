import Foundation

protocol AIAnalysisService: Sendable {
    func generateAnalysis(
        for session: DrinkingSession,
        comparisons: [MetricComparison],
        recentSessions: [DrinkingSession]
    ) async throws -> AIAnalysis
}
