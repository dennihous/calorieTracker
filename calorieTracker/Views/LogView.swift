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
            ScrollView {
                VStack(spacing: 16) {
                    // Editing banner
                    if draft.isEditing {
                        HStack(spacing: 8) {
                            Image(systemName: "pencil.circle.fill")
                            Text("Editing existing entry")
                            Spacer()
                            Button("Cancel") { draft.clear() }
                        }
                        .padding(12)
                        .background(Color.orange.opacity(0.1), in: RoundedRectangle(cornerRadius: 10))
                    }

                    // Input Card
                    GroupBox {
                        VStack(alignment: .leading, spacing: 12) {
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

                            HStack(spacing: 8) {
                                TextField("Calories", value: $draft.calories, formatter: calorieFormatter)
                                    .keyboardType(.numberPad)
                                    .textFieldStyle(.roundedBorder)
                                    .focused($focusedField, equals: .calories)

                                Button(action: saveEntry) {
                                    Label(draft.isEditing ? "Update" : "Add", systemImage: draft.isEditing ? "square.and.arrow.down" : "checkmark.circle.fill")
                                }
                                .buttonStyle(.borderedProminent)
                                .disabled(!canSave)
                            }
                        }
                    } label: {
                        Label("Add Item", systemImage: "plus")
                    }

                    // Summary
                    HStack {
                        Label("Total", systemImage: "flame.fill")
                        Spacer()
                        Text("\(dayTotal) kcal").bold()
                    }
                    .padding(.horizontal)

                    // Entries List for selected date
                    VStack(alignment: .leading, spacing: 8) {
                        Text(formatted(draft.date))
                            .font(.headline)
                            .padding(.horizontal)

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
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 24)
                        } else {
                            LazyVStack(spacing: 0) {
                                ForEach(store.entries(on: draft.date)) { entry in
                                    HStack(spacing: 12) {
                                        Image(systemName: entry.meal.symbol)
                                        VStack(alignment: .leading) {
                                            Text(entry.name).font(.headline)
                                            Text(entry.meal.title).font(.caption).foregroundStyle(.secondary)
                                        }
                                        Spacer()
                                        Text("\(entry.calories) kcal")
                                        Menu {
                                            Button { startEditing(entry) } label: { Label("Edit", systemImage: "pencil") }
                                            Button(role: .destructive) { store.remove(entry) } label: { Label("Delete", systemImage: "trash") }
                                        } label: {
                                            Image(systemName: "ellipsis.circle")
                                        }
                                    }
                                    .padding(.horizontal)
                                    .padding(.vertical, 8)
                                    .background(Color(.systemBackground))
                                    Divider()
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Calorie Log")
            .toolbar { toolbarKeyboardDone }
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
