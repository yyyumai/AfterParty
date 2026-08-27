import SwiftUI

struct SessionDetailView: View {
    @EnvironmentObject private var store: SessionStore
    @StateObject private var viewModel = AnalysisViewModel()

    let session: DrinkingSession

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                header
                bodyResponse
                sessionContext
                detailLinks
            }
            .padding(20)
        }
        .background(Color(red: 0.04, green: 0.05, blue: 0.07).ignoresSafeArea())
        .navigationTitle("Analysis")
        .navigationBarTitleDisplayMode(.inline)
        .task(id: session.id) {
            await viewModel.load(session: session, recentSessions: recentSessions)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(session.startDate, format: .dateTime.month(.wide).day().hour().minute())
                .font(.title.weight(.bold))
            Text(session.drinkCountText)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var bodyResponse: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Body Response")
                    .font(.title2.weight(.bold))
                Spacer()
                if viewModel.isLoading {
                    ProgressView()
                }
            }

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 12)], spacing: 12) {
                ForEach(viewModel.comparisons) { comparison in
                    MetricCard(comparison: comparison)
                }
            }

            if deviationLabel != nil {
                Text(deviationLabel ?? "")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.secondary)
                    .padding(.top, 2)
            }
        }
    }

    private var sessionContext: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Session Details")
                .font(.title2.weight(.bold))

            VStack(alignment: .leading, spacing: 8) {
                ForEach(session.drinks) { drink in
                    DrinkRow(drink: drink)
                }
            }
            .padding(16)
            .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 8, style: .continuous))

            if !session.sortedTags.isEmpty {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 120), spacing: 10)], alignment: .leading, spacing: 10) {
                    ForEach(session.sortedTags) { tag in
                        ContextChip(title: tag.displayName, isSelected: true) {}
                    }
                }
            }

            if !session.memo.isEmpty {
                Text(session.memo)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
            }
        }
    }

    private var detailLinks: some View {
        VStack(spacing: 12) {
            NavigationLink {
                ComparisonView(comparisons: viewModel.comparisons)
            } label: {
                navRow("Before vs After", symbol: "arrow.left.arrow.right")
            }

            NavigationLink {
                TimelineView(session: session)
            } label: {
                navRow("Timeline", symbol: "chart.xyaxis.line")
            }

            NavigationLink {
                AIAnalysisView(analysis: viewModel.analysis)
            } label: {
                navRow("AI Insight", symbol: "sparkles")
            }

            NavigationLink {
                UserAnalysisView(userAnalysis: viewModel.userAnalysis)
            } label: {
                navRow("User Analysis", symbol: "person.crop.circle.badge.chart.bar")
            }
        }
        .buttonStyle(.plain)
    }

    private func navRow(_ title: String, symbol: String) -> some View {
        HStack {
            Label(title, systemImage: symbol)
                .font(.headline)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption.weight(.bold))
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
    }

    private var recentSessions: [DrinkingSession] {
        store.sessions.filter { $0.id != session.id }
    }

    private var deviationLabel: String? {
        let count = viewModel.comparisons.filter { abs($0.changePercent) >= 8 }.count
        return count >= 2 ? "Overall deviation from baseline: HIGH" : nil
    }
}
