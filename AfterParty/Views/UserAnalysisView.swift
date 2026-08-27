import SwiftUI

struct UserAnalysisView: View {
    let userAnalysis: UserAnalysis

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 10) {
                    Label("User Analysis", systemImage: "person.crop.circle.badge.chart.bar")
                        .font(.largeTitle.weight(.bold))
                        .foregroundStyle(.mint)

                    Text(userAnalysis.responseLabel)
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.black)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(.mint, in: Capsule())
                }

                Text(userAnalysis.headline)
                    .font(.title3.weight(.semibold))
                    .lineSpacing(3)

                Text(userAnalysis.comparisonText)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 8, style: .continuous))

                analysisSection("Metric Traits", items: userAnalysis.metricTraits, symbol: "waveform.path.ecg")
                analysisSection("Context Traits", items: userAnalysis.contextTraits, symbol: "tag")
                analysisSection("Boundaries", items: userAnalysis.notes, symbol: "checkmark.shield")
            }
            .padding(20)
        }
        .background(Color(red: 0.04, green: 0.05, blue: 0.07).ignoresSafeArea())
    }

    private func analysisSection(_ title: String, items: [String], symbol: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(title, systemImage: symbol)
                .font(.headline)
            if items.isEmpty {
                Text("More recorded sessions will make this section richer.")
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
