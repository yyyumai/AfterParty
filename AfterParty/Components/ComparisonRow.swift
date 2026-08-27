import SwiftUI

struct ComparisonRow: View {
    let comparison: MetricComparison

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label(comparison.kind.fullTitle, systemImage: comparison.kind.symbolName)
                    .font(.headline)
                    .foregroundStyle(comparison.kind.tint)
                Spacer()
                Text(comparison.formattedPercent)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(comparison.changePercent >= 0 ? .orange : .mint)
            }

            HStack(spacing: 18) {
                valueBlock(title: "Before", value: comparison.formattedBaseline)
                Image(systemName: "arrow.right")
                    .foregroundStyle(.secondary)
                valueBlock(title: "After", value: comparison.formattedSession)
            }
        }
        .padding(16)
        .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
    }

    private func valueBlock(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title.uppercased())
                .font(.caption2.weight(.bold))
                .foregroundStyle(.secondary)
            Text(value)
                .font(.title3.weight(.semibold))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
