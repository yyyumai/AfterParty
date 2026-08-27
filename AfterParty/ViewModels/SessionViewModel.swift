import Foundation

@MainActor
final class SessionViewModel: ObservableObject {
    @Published var date: Date
    @Published var startTime: Date
    @Published var endTime: Date
    @Published var drinks: [DrinkEntry]
    @Published var selectedTags: Set<ContextTag>
    @Published var memo: String

    init(now: Date = .now) {
        let calendar = Calendar.current
        self.date = now
        self.startTime = calendar.date(bySettingHour: 19, minute: 0, second: 0, of: now) ?? now
        self.endTime = calendar.date(bySettingHour: 23, minute: 0, second: 0, of: now) ?? now
        self.drinks = []
        self.selectedTags = []
        self.memo = ""
    }

    var canSave: Bool {
        !drinks.isEmpty && resolvedEndDate > resolvedStartDate
    }

    func addDrink(_ drink: DrinkEntry) {
        drinks.append(drink)
    }

    func removeDrinks(at offsets: IndexSet) {
        drinks.remove(atOffsets: offsets)
    }

    func toggleTag(_ tag: ContextTag) {
        if selectedTags.contains(tag) {
            selectedTags.remove(tag)
        } else {
            selectedTags.insert(tag)
        }
    }

    func makeSession() -> DrinkingSession {
        DrinkingSession(
            startDate: resolvedStartDate,
            endDate: resolvedEndDate,
            drinks: drinks,
            contextTags: selectedTags,
            memo: memo.trimmingCharacters(in: .whitespacesAndNewlines)
        )
    }

    private var resolvedStartDate: Date {
        combine(date: date, time: startTime)
    }

    private var resolvedEndDate: Date {
        let combined = combine(date: date, time: endTime)
        if combined <= resolvedStartDate {
            return Calendar.current.date(byAdding: .day, value: 1, to: combined) ?? combined
        }
        return combined
    }

    private func combine(date: Date, time: Date) -> Date {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: time)

        var components = DateComponents()
        components.year = dateComponents.year
        components.month = dateComponents.month
        components.day = dateComponents.day
        components.hour = timeComponents.hour
        components.minute = timeComponents.minute
        return calendar.date(from: components) ?? date
    }
}
