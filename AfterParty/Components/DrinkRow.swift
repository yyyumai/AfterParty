import SwiftUI

struct DrinkRow: View {
    let drink: DrinkEntry

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: drink.type.symbolName)
                .font(.headline)
                .foregroundStyle(.teal)
                .frame(width: 34, height: 34)
                .background(.teal.opacity(0.16), in: Circle())

            VStack(alignment: .leading, spacing: 3) {
                Text(drink.type.displayName)
                    .font(.subheadline.weight(.semibold))
                Text("\(Int(drink.volumeML)) ml")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            if let timestamp = drink.timestamp {
                Text(timestamp, format: .dateTime.hour().minute())
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 6)
    }
}
