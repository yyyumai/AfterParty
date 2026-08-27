import SwiftUI

struct AddDrinkView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var type: DrinkType = .beer
    @State private var volumeML = 350.0
    @State private var includeTimestamp = true
    @State private var timestamp = Date()

    let onAdd: (DrinkEntry) -> Void

    var body: some View {
        Form {
            Section("Drink") {
                Picker("Type", selection: $type) {
                    ForEach(DrinkType.allCases) { drinkType in
                        Label(drinkType.displayName, systemImage: drinkType.symbolName)
                            .tag(drinkType)
                    }
                }

                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Volume")
                        Spacer()
                        Text("\(Int(volumeML)) ml")
                            .foregroundStyle(.secondary)
                    }
                    Slider(value: $volumeML, in: 50...700, step: 10)
                }

                Toggle("Add time", isOn: $includeTimestamp)
                if includeTimestamp {
                    DatePicker("Time", selection: $timestamp, displayedComponents: .hourAndMinute)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color(red: 0.04, green: 0.05, blue: 0.07))
        .navigationTitle("Add Drink")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Add") {
                    onAdd(DrinkEntry(
                        type: type,
                        volumeML: volumeML,
                        timestamp: includeTimestamp ? timestamp : nil
                    ))
                    dismiss()
                }
            }
        }
    }
}
