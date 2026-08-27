import SwiftUI

@main
struct AfterPartyApp: App {
    @StateObject private var sessionStore = SessionStore()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(sessionStore)
                .preferredColorScheme(.dark)
        }
    }
}
