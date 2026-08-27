import Foundation

struct AIAnalysis: Hashable, Sendable {
    var summary: String
    var observations: [String]
    var possibleContext: [String]
    var dataQuality: String

    static let placeholder = AIAnalysis(
        summary: "Mock insight will appear after session metrics load.",
        observations: [],
        possibleContext: [],
        dataQuality: "No data has been analyzed yet."
    )
}
