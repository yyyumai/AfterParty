import SwiftUI

struct CreateSessionView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: SessionStore
    @StateObject private var viewModel = SessionViewModel()
    @State private var isAddingDrink = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                dateSection
                drinksSection
                contextSection
                memoSection
            }
            .padding(20)
        }
        .background(Color(red: 0.04, green: 0.05, blue: 0.07).ignoresSafeArea())
        .navigationTitle("New Session")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    store.add(viewModel.makeSession())
                    dismiss()
                }
                .disabled(!viewModel.canSave)
            }
        }
        .sheet(isPresented: $isAddingDrink) {
            NavigationStack {
                AddDrinkView { drink in
                    viewModel.addDrink(drink)
                }
            }
        }
    }

    private var dateSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionTitle("Session")
            DatePicker("Date", selection: $viewModel.date, displayedComponents: .date)
            DatePicker("Approx Start", selection: $viewModel.startTime, displayedComponents: .hourAndMinute)
            DatePicker("Approx End", selection: $viewModel.endTime, displayedComponents: .hourAndMinute)
        }
        .sectionCard()
    }

    private var drinksSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                sectionTitle("Drinks")
                Spacer()
                Button {
                    isAddingDrink = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                }
                .accessibilityLabel("Add Drink")
            }

            if viewModel.drinks.isEmpty {
                Text("Add each drink as a quantity record.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(viewModel.drinks) { drink in
                    DrinkRow(drink: drink)
                }
                .onDelete(perform: viewModel.removeDrinks)
            }
        }
        .sectionCard()
    }

    private var contextSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionTitle("Context")
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 128), spacing: 10)], alignment: .leading, spacing: 10) {
                ForEach(ContextTag.allCases) { tag in
                    ContextChip(title: tag.displayName, isSelected: viewModel.selectedTags.contains(tag)) {
                        viewModel.toggleTag(tag)
                    }
                }
            }
        }
        .sectionCard()
    }

    private var memoSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionTitle("Memo")
            TextEditor(text: $viewModel.memo)
                .frame(minHeight: 120)
                .padding(10)
                .scrollContentBackground(.hidden)
                .background(.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
        .sectionCard()
    }

    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.headline.weight(.bold))
    }
}

private extension View {
    func sectionCard() -> some View {
        padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}
