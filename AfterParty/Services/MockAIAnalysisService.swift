import Foundation

struct MockAIAnalysisService: AIAnalysisService {
    func generateAnalysis(
        for session: DrinkingSession,
        comparisons: [MetricComparison],
        recentSessions: [DrinkingSession]
    ) async throws -> AIAnalysis {
        let heartRate = comparisons.first { $0.kind == .heartRate }
        let hrv = comparisons.first { $0.kind == .hrv }
        let resting = comparisons.first { $0.kind == .restingHeartRate }
        let tagNames = session.sortedTags.map(\.displayName)

        var observations: [String] = []
        if let heartRate, heartRate.changePercent > 0 {
            observations.append("Heart rate was above your personal baseline.")
        }
        if let hrv, hrv.changePercent < 0 {
            observations.append("HRV was below your personal baseline.")
        }
        if let resting, resting.changePercent > 0 {
            observations.append("Resting heart rate was elevated compared with your baseline.")
        }

        var context: [String] = []
        if session.contextTags.contains(.exercise) {
            context.append("Exercise was recorded and may also influence heart rate changes.")
        }
        if session.contextTags.contains(.poorSleep) || session.contextTags.contains(.tired) {
            context.append("Sleep or tiredness tags may be relevant when reviewing HRV differences.")
        }
        if session.contextTags.contains(.stress) {
            context.append("Stress was recorded, which can overlap with changes in cardiovascular metrics.")
        }
        if context.isEmpty, !tagNames.isEmpty {
            context.append("\(tagNames.joined(separator: ", ")) may be useful context when comparing sessions.")
        }

        let deviationCount = comparisons.filter { abs($0.changePercent) >= 8 }.count
        let summary = deviationCount >= 2
            ? "Your physiological metrics differed more from baseline than in several recent mock sessions."
            : "This session shows modest differences from your personal baseline."

        return AIAnalysis(
            summary: summary,
            observations: observations,
            possibleContext: context,
            dataQuality: "Several factors were present, so this retrospective cannot determine a single cause or provide a medical conclusion."
        )
    }
}
