import SwiftUI

struct MetricCard: View {
    let comparison: MetricComparison

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Image(systemName: comparison.kind.symbolName)
                    .font(.headline)
                    .foregroundStyle(comparison.kind.tint)
                Spacer()
                Label(comparison.formattedPercent, systemImage: comparison.directionSymbol)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(comparison.changePercent >= 0 ? .orange : .mint)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(comparison.kind.title)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(comparison.formattedSession)
                    .font(.title2.weight(.bold))
            }

            Text("Baseline \(comparison.formattedBaseline)")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}
