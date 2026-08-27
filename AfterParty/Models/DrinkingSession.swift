import Foundation

struct DrinkingSession: Identifiable, Codable, Hashable, Sendable {
    let id: UUID
    var startDate: Date
    var endDate: Date
    var drinks: [DrinkEntry]
    var contextTags: Set<ContextTag>
    var memo: String
    var createdAt: Date

    init(
        id: UUID = UUID(),
        startDate: Date,
        endDate: Date,
        drinks: [DrinkEntry],
        contextTags: Set<ContextTag>,
        memo: String,
        createdAt: Date = .now
    ) {
        self.id = id
        self.startDate = startDate
        self.endDate = endDate
        self.drinks = drinks
        self.contextTags = contextTags
        self.memo = memo
        self.createdAt = createdAt
    }

    var drinkCountText: String {
        drinks.count == 1 ? "1 drink recorded" : "\(drinks.count) drinks recorded"
    }

    var sortedTags: [ContextTag] {
        contextTags.sorted { $0.displayName < $1.displayName }
    }
}
