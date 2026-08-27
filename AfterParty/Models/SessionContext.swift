import Foundation

enum ContextTag: String, CaseIterable, Identifiable, Codable, Hashable, Sendable {
    case exercise
    case poorSleep
    case stress
    case tired
    case emptyStomach
    case afterMeal
    case caffeine
    case other

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .exercise: "Exercise"
        case .poorSleep: "Poor Sleep"
        case .stress: "Stress"
        case .tired: "Tired"
        case .emptyStomach: "Empty Stomach"
        case .afterMeal: "After Meal"
        case .caffeine: "Caffeine"
        case .other: "Other"
        }
    }

    var analysisKey: String {
        switch self {
        case .exercise: "exercise"
        case .poorSleep: "poor_sleep"
        case .stress: "stress"
        case .tired: "tired"
        case .emptyStomach: "empty_stomach"
        case .afterMeal: "after_meal"
        case .caffeine: "caffeine"
        case .other: "other"
        }
    }
}
