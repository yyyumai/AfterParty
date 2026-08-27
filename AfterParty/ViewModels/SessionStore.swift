import Foundation

@MainActor
final class SessionStore: ObservableObject {
    @Published private(set) var sessions: [DrinkingSession]

    init(sessions: [DrinkingSession] = MockSessions.samples) {
        self.sessions = sessions.sorted { $0.startDate > $1.startDate }
    }

    var latestSession: DrinkingSession? {
        sessions.first
    }

    func add(_ session: DrinkingSession) {
        sessions.insert(session, at: 0)
        sessions.sort { $0.startDate > $1.startDate }
    }
}
