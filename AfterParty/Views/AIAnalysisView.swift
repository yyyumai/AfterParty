import SwiftUI

struct AIAnalysisView: View {
    let analysis: AIAnalysis

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Label("AI Insight", systemImage: "sparkles")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.mint)

                Text(analysis.summary)
                    .font(.title3.weight(.semibold))
                    .lineSpacing(3)

                insightSection("What stood out", items: analysis.observations)
                insightSection("Context", items: analysis.possibleContext)

                Text(analysis.dataQuality)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(16)
                    .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
            }
            .padding(20)
        }
        .background(Color(red: 0.04, green: 0.05, blue: 0.07).ignoresSafeArea())
    }

    private func insightSection(_ title: String, items: [String]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
            if items.isEmpty {
                Text("No notable mock observations for this section.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(items, id: \.self) { item in
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "circle.fill")
                            .font(.system(size: 6))
                            .padding(.top, 7)
                            .foregroundStyle(.mint)
                        Text(item)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}
