import SwiftUI

struct HistoryView: View {
    @EnvironmentObject private var store: SessionStore

    var body: some View {
        List {
            ForEach(store.sessions) { session in
                NavigationLink {
                    SessionDetailView(session: session)
                } label: {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(session.startDate, format: .dateTime.month(.abbreviated).day())
                                .font(.headline)
                            Spacer()
                            Text(session.drinkCountText)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        if !session.sortedTags.isEmpty {
                            Text(session.sortedTags.map(\.displayName).joined(separator: " · "))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Text("HR and HRV changes use mock personal baselines.")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 6)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color(red: 0.04, green: 0.05, blue: 0.07).ignoresSafeArea())
        .navigationTitle("Session History")
    }
}
