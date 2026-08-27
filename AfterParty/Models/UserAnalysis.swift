import Foundation

struct SessionMetricSnapshot: Identifiable, Hashable, Sendable {
    var id: UUID
    var sessionDate: Date
    var drinkCount: Int
    var tags: [ContextTag]
    var comparisons: [MetricComparison]

    var averageDeviationPercent: Double {
        guard !comparisons.isEmpty else { return 0 }
        let total = comparisons.reduce(0) { $0 + abs($1.changePercent) }
        return total / Double(comparisons.count)
    }
}

struct UserAnalysis: Hashable, Sendable {
    var responseLabel: String
    var headline: String
    var comparisonText: String
    var metricTraits: [String]
    var contextTraits: [String]
    var notes: [String]

    static let placeholder = UserAnalysis(
        responseLabel: "Analyzing",
        headline: "User analysis will appear after mock metrics load.",
        comparisonText: "This compares only your own recorded sessions.",
        metricTraits: [],
        contextTraits: [],
        notes: []
    )
}
