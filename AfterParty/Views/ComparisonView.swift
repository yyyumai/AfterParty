import SwiftUI

struct ComparisonView: View {
    let comparisons: [MetricComparison]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text("Before vs After")
                    .font(.largeTitle.weight(.bold))
                Text("Compared only with your personal mock baseline.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                ForEach(comparisons) { comparison in
                    ComparisonRow(comparison: comparison)
                }
            }
            .padding(20)
        }
        .background(Color(red: 0.04, green: 0.05, blue: 0.07).ignoresSafeArea())
    }
}
