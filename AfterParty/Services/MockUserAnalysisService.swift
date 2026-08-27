import Foundation

struct MockUserAnalysisService: UserAnalysisService {
    func generateUserAnalysis(
        for session: DrinkingSession,
        currentComparisons: [MetricComparison],
        recentSnapshots: [SessionMetricSnapshot]
    ) async throws -> UserAnalysis {
        let currentDeviation = averageDeviation(currentComparisons)
        let recentDeviation = averageDeviation(recentSnapshots.map(\.averageDeviationPercent))
        let strongestMetric = currentComparisons.max { abs($0.changePercent) < abs($1.changePercent) }
        let commonTags = commonContextTags(in: recentSnapshots + [snapshot(for: session, comparisons: currentComparisons)])

        let responseLabel: String
        let headline: String
        let comparisonText: String

        if recentSnapshots.isEmpty {
            responseLabel = "Early Pattern"
            headline = "A few more sessions will make this pattern more useful."
            comparisonText = "For now, this is based on the current session and mock baseline only."
        } else if currentDeviation >= recentDeviation * 1.2 {
            responseLabel = "Higher Response"
            headline = "This session shows larger body-metric changes than your recent mock history."
            comparisonText = "Average metric deviation was \(formatted(currentDeviation)) vs \(formatted(recentDeviation)) across recent sessions."
        } else if currentDeviation <= recentDeviation * 0.8 {
            responseLabel = "Lower Response"
            headline = "This session shows smaller body-metric changes than your recent mock history."
            comparisonText = "Average metric deviation was \(formatted(currentDeviation)) vs \(formatted(recentDeviation)) across recent sessions."
        } else {
            responseLabel = "Typical Response"
            headline = "This session is close to your recent personal pattern."
            comparisonText = "Average metric deviation was \(formatted(currentDeviation)) vs \(formatted(recentDeviation)) across recent sessions."
        }

        var metricTraits: [String] = []
        if let strongestMetric {
            metricTraits.append("\(strongestMetric.kind.fullTitle) showed the most noticeable difference in this session: \(strongestMetric.formattedPercent).")
        }

        if let hrv = currentComparisons.first(where: { $0.kind == .hrv }), hrv.changePercent < -10 {
            metricTraits.append("HRV is one of the clearer signals to review in this mock data.")
        }

        let contextTraits = commonTags.prefix(3).map { entry in
            let (tag, count) = entry
            return "\(tag.displayName) appears in \(count) recorded sessions, so it may be worth checking alongside metric changes."
        }

        let notes = [
            "This does not classify alcohol tolerance or compare you with other people.",
            "Patterns describe observable changes against your own baseline and history.",
            "Context tags can overlap, so the app should not infer a single cause."
        ]

        return UserAnalysis(
            responseLabel: responseLabel,
            headline: headline,
            comparisonText: comparisonText,
            metricTraits: metricTraits,
            contextTraits: Array(contextTraits),
            notes: notes
        )
    }

    private func averageDeviation(_ comparisons: [MetricComparison]) -> Double {
        guard !comparisons.isEmpty else { return 0 }
        return comparisons.reduce(0) { $0 + abs($1.changePercent) } / Double(comparisons.count)
    }

    private func averageDeviation(_ values: [Double]) -> Double {
        guard !values.isEmpty else { return 0 }
        return values.reduce(0, +) / Double(values.count)
    }

    private func commonContextTags(in snapshots: [SessionMetricSnapshot]) -> [(ContextTag, Int)] {
        var counts: [ContextTag: Int] = [:]
        for snapshot in snapshots {
            for tag in snapshot.tags {
                counts[tag, default: 0] += 1
            }
        }
        return counts.sorted {
            if $0.value == $1.value {
                return $0.key.displayName < $1.key.displayName
            }
            return $0.value > $1.value
        }
    }

    private func snapshot(for session: DrinkingSession, comparisons: [MetricComparison]) -> SessionMetricSnapshot {
        SessionMetricSnapshot(
            id: session.id,
            sessionDate: session.startDate,
            drinkCount: session.drinks.count,
            tags: session.sortedTags,
            comparisons: comparisons
        )
    }

    private func formatted(_ value: Double) -> String {
        "\(Int(round(value)))%"
    }
}
