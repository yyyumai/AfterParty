import Foundation

enum DrinkType: String, CaseIterable, Identifiable, Codable, Sendable {
    case beer
    case wine
    case highball
    case cocktail
    case other

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .beer: "Beer"
        case .wine: "Wine"
        case .highball: "Highball"
        case .cocktail: "Cocktail"
        case .other: "Other"
        }
    }

    var symbolName: String {
        switch self {
        case .beer: "mug"
        case .wine: "wineglass"
        case .highball: "tumbler"
        case .cocktail: "sparkles"
        case .other: "drop"
        }
    }
}

struct DrinkEntry: Identifiable, Codable, Hashable, Sendable {
    let id: UUID
    var type: DrinkType
    var volumeML: Double
    var timestamp: Date?

    init(id: UUID = UUID(), type: DrinkType, volumeML: Double, timestamp: Date? = nil) {
        self.id = id
        self.type = type
        self.volumeML = volumeML
        self.timestamp = timestamp
    }
}
