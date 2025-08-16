//
//  LogView.swift
//  calorieTracker
//
//  Created by Sam Houston on 16/08/2025.
//

import SwiftUI

struct LogView: View {
    @EnvironmentObject private var store: CalorieStore
    @EnvironmentObject private var draft: EntryDraft

    @FocusState private var focusedField: Field?
    enum Field { case name, calories }

    private let fieldHeight: CGFloat = 44

    private var dayTotal: Int { store.totalCalories(on: draft.date) }

    private var calorieFormatter: NumberFormatter {
        let nf = NumberFormatter()
        nf.allowsFloats = false
        nf.minimum = 0
        nf.maximum = 100_000
        return nf
    }

    var body: some View {
        NavigationStack {
            GeometryReader { proxy in
                // Same pattern as Calendar: fixed entries panel height
                let panelHeight = max(300, proxy.size.height * 0.56)

                ScrollView {
                    VStack(alignment: .leading, spacing: UI.outerSpacing) {

                        // Editing banner
                        if draft.isEditing {
                            HStack(spacing: 8) {
                                Image(systemName: "pencil.circle.fill")
                                Text("Editing existing entry").font(.subheadline)
                                Spacer()
                                Button("Cancel") { draft.clear() }
                            }
                            .softCard()
                        }

                        // Input card
                        VStack(alignment: .leading, spacing: UI.innerSpacing) {

                            DatePicker("Date", selection: $draft.date, displayedComponents: [.date])
                                .datePickerStyle(.compact)

                            Picker("Meal", selection: $draft.meal) {
                                ForEach(MealType.allCases) { m in
                                    Label(m.title, systemImage: m.symbol).tag(m)
                                }
                            }
                            .pickerStyle(.segmented)

                            TextField("Food or drink name", text: $draft.name)
                                .textInputAutocapitalization(.words)
                                .textFieldStyle(.roundedBorder)
                                .focused($focusedField, equals: .name)
                                .submitLabel(.next)
                                .onSubmit { focusedField = .calories }

                            // Calories field and Add/Update button
                            HStack(spacing: 8) {
                                TextField("Calories", value: $draft.calories, formatter: calorieFormatter)
                                    .keyboardType(.numberPad)
                                    .textFieldStyle(.roundedBorder)
                                    .focused($focusedField, equals: .calories)
                                    .monospacedDigit()
                                    .frame(height: fieldHeight)
                                    .frame(maxWidth: .infinity)

                                Button(action: saveEntry) {
                                    Label(
                                        draft.isEditing ? "Update" : "Add",
                                        systemImage: draft.isEditing ? "square.and.arrow.down" : "checkmark.circle.fill"
                                    )
                                }
                                .buttonStyle(EqualHeightFilledButtonStyle(height: 33))
                                .disabled(!canSave)
                                .frame(maxWidth: .infinity)
                            }
                        }
                        .softCard()

                        // Summary
                        HStack(alignment: .firstTextBaseline) {
                            Label("Total", systemImage: "flame.fill")
                            Spacer()
                            Text("\(dayTotal) kcal")
                                .bold()
                                .monospacedDigit()
                                .pillBackground()
                        }
                        .padding(.horizontal, UI.outerSpacing)

                        VStack(alignment: .leading, spacing: 10) {
                            HStack(alignment: .firstTextBaseline) {
                                Text(formatted(draft.date)).font(.headline)
                                Spacer()
                                HStack(spacing: 6) {
                                    Image(systemName: "flame.fill")
                                    Text("\(store.totalCalories(on: draft.date)) kcal")
                                        .bold().monospacedDigit()
                                }
                                .pillBackground()
                            }

                            Divider()

                            if store.entries(on: draft.date).isEmpty {
                                VStack(spacing: 8) {
                                    Image(systemName: "fork.knife.circle")
                                        .font(.largeTitle)
                                        .foregroundStyle(.secondary)
                                    Text("No entries yet").foregroundStyle(.secondary)
                                    Text("Add your first item above.")
                                        .font(.footnote)
                                        .foregroundStyle(.secondary)
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                            } else {
                                ScrollView {
                                    VStack(spacing: 12) {
                                        ForEach(store.entries(on: draft.date)) { entry in
                                            EntryRow(
                                                entry: entry,
                                                onEdit: { startEditing(entry) },
                                                onDelete: { store.remove(entry) }
                                            )
                                        }
                                    }
                                    .padding(.vertical, 4)
                                }
                                .scrollIndicators(.visible)
                            }
                        }
                        .softCard()
                        .frame(height: panelHeight)
                    }
                    .padding(.vertical, UI.outerSpacing)
                }
            }
            .background(
                LinearGradient(
                    colors: [Color(.systemGroupedBackground), Color(.secondarySystemGroupedBackground)],
                    startPoint: .top, endPoint: .bottom
                ).ignoresSafeArea()
            )

            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Calorie Log")
                        .font(.title2.weight(.bold))
                        .lineLimit(1)
                        .minimumScaleFactor(0.85)
                }
            }
            .toolbar { toolbarKeyboardDone }
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 10)
            }
        }
    }

    private var canSave: Bool {
        (draft.calories ?? 0) > 0 && !draft.name.trimmingCharacters(in: .whitespaces).isEmpty
    }

    private func startEditing(_ entry: FoodEntry) {
        draft.load(from: entry)
        focusedField = .name
    }

    private func saveEntry() {
        guard let cals = draft.calories, cals > 0 else { return }
        let trimmed = draft.name.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }

        if let original = draft.editingEntry {
            let updated = FoodEntry(id: original.id, date: draft.date, name: trimmed, calories: cals, meal: draft.meal)
            store.replace(old: original, with: updated)
        } else {
            let new = FoodEntry(date: draft.date, name: trimmed, calories: cals, meal: draft.meal)
            store.add(new)
        }
        draft.clear()
        focusedField = .name
    }

    @ToolbarContentBuilder private var toolbarKeyboardDone: some ToolbarContent {
        ToolbarItemGroup(placement: .keyboard) {
            Spacer()
            Button("Done") { focusedField = nil }
        }
    }

    private func formatted(_ date: Date) -> String {
        let df = DateFormatter()
        df.dateStyle = .full
        return df.string(from: date)
    }
}

private struct EqualHeightFilledButtonStyle: ButtonStyle {
    var height: CGFloat = 44
    var cornerRadius: CGFloat = 5

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity, minHeight: height)
            .padding(.horizontal, 12)
            .background(configuration.isPressed ? Color.accentColor.opacity(0.85) : Color.accentColor)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(Color.accentColor.opacity(0.65), lineWidth: 0.5)
            )
            .animation(.easeInOut(duration: 0.08), value: configuration.isPressed)
    }
}

