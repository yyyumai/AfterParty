import Foundation

protocol HealthDataService: Sendable {
    func fetchMetrics(from startDate: Date, to endDate: Date) async throws -> [HealthMetric]
    func fetchBaseline(before date: Date) async throws -> Baseline
    func fetchTimeline(for kind: HealthMetricKind, session: DrinkingSession) async throws -> [HealthMetric]
}
