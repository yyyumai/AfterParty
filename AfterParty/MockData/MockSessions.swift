import Foundation

enum MockSessions {
    static var samples: [DrinkingSession] {
        [
            makeSession(daysAgo: 0, drinks: [
                DrinkEntry(type: .beer, volumeML: 350),
                DrinkEntry(type: .highball, volumeML: 300),
                DrinkEntry(type: .wine, volumeML: 150)
            ], tags: [.exercise, .poorSleep, .afterMeal], memo: "Had soccer practice earlier and slept about 5 hours."),
            makeSession(daysAgo: 8, drinks: [
                DrinkEntry(type: .wine, volumeML: 150),
                DrinkEntry(type: .cocktail, volumeML: 120)
            ], tags: [.afterMeal], memo: "Dinner with friends after work."),
            makeSession(daysAgo: 15, drinks: [
                DrinkEntry(type: .beer, volumeML: 350),
                DrinkEntry(type: .beer, volumeML: 350),
                DrinkEntry(type: .highball, volumeML: 300)
            ], tags: [.stress, .tired], memo: "Late night after a long deadline.")
        ]
    }

    private static func makeSession(
        daysAgo: Int,
        drinks: [DrinkEntry],
        tags: Set<ContextTag>,
        memo: String
    ) -> DrinkingSession {
        let calendar = Calendar.current
        let day = calendar.date(byAdding: .day, value: -daysAgo, to: .now) ?? .now
        let start = calendar.date(bySettingHour: 19, minute: 30, second: 0, of: day) ?? day
        let end = calendar.date(byAdding: .hour, value: 4, to: start) ?? start

        let timedDrinks = drinks.enumerated().map { index, drink in
            var copy = drink
            copy.timestamp = calendar.date(byAdding: .minute, value: index * 55, to: start)
            return copy
        }

        return DrinkingSession(
            startDate: start,
            endDate: end,
            drinks: timedDrinks,
            contextTags: tags,
            memo: memo
        )
    }
}
