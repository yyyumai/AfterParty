import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var store: SessionStore
    @StateObject private var viewModel = HomeViewModel()
    @State private var isCreatingSession = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    header

                    if let latest = store.latestSession {
                        latestSessionCard(latest)
                    } else {
                        emptyState
                    }

                    trendCard

                    recentSessions
                }
                .padding(20)
            }
            .background(background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isCreatingSession = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Create Session")
                }
            }
            .sheet(isPresented: $isCreatingSession) {
                NavigationStack {
                    CreateSessionView()
                        .environmentObject(store)
                }
            }
            .task(id: store.latestSession?.id) {
                await viewModel.loadLatestSummary(for: store.latestSession)
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("AfterParty")
                .font(.system(size: 42, weight: .bold))
            Text("Retrospective body metrics around logged sessions.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 16)
    }

    private func latestSessionCard(_ session: DrinkingSession) -> some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Last Session")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.secondary)
                    Text(session.startDate, format: .dateTime.month(.abbreviated).day())
                        .font(.title.weight(.bold))
                    Text(session.drinkCountText)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.title2)
                    .foregroundStyle(.mint)
            }

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 130), spacing: 12)], spacing: 12) {
                ForEach(viewModel.comparisons) { comparison in
                    MetricCard(comparison: comparison)
                }
            }

            NavigationLink {
                SessionDetailView(session: session)
            } label: {
                Label("View Analysis", systemImage: "arrow.right.circle.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
            }
            .buttonStyle(.borderedProminent)
            .tint(.mint)
        }
        .padding(18)
        .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
    }

    private var trendCard: some View {
        HStack(spacing: 14) {
            Image(systemName: "person.text.rectangle")
                .foregroundStyle(.teal)
                .font(.title3)
            Text(viewModel.trendSummary)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.secondary)
            Spacer()
        }
        .padding(16)
        .background(.teal.opacity(0.12), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
    }

    private var recentSessions: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Recent Sessions")
                    .font(.title2.weight(.bold))
                Spacer()
                NavigationLink("History") {
                    HistoryView()
                }
                .font(.subheadline.weight(.semibold))
            }

            ForEach(store.sessions.prefix(3)) { session in
                NavigationLink {
                    SessionDetailView(session: session)
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(session.startDate, format: .dateTime.month(.abbreviated).day())
                                .font(.headline)
                                .foregroundStyle(.white)
                            Text(session.drinkCountText)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.secondary)
                    }
                    .padding(16)
                    .background(.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var emptyState: some View {
        VStack(alignment: .leading, spacing: 14) {
            Image(systemName: "plus.circle.fill")
                .font(.largeTitle)
                .foregroundStyle(.mint)
            Text("Create your first session")
                .font(.title2.weight(.bold))
            Text("Add drinks, context, and notes, then compare mock body metrics against your personal baseline.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Button {
                isCreatingSession = true
            } label: {
                Label("New Session", systemImage: "plus")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.mint)
        }
        .padding(18)
        .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
    }

    private var background: some View {
        LinearGradient(
            colors: [Color(red: 0.04, green: 0.05, blue: 0.07), Color(red: 0.08, green: 0.10, blue: 0.12)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}
