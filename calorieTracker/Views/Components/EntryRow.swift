//
//  EntryRow.swift
//  calorieTracker
//
//  Created by Sam Houston on 16/08/2025.
//

import SwiftUI

struct EntryRow: View {
    let entry: FoodEntry
    var onEdit: () -> Void
    var onDelete: () -> Void

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            ZStack {
                Circle()
                    .fill(entry.meal.color.opacity(0.18))
                    .frame(width: 34, height: 34)
                Image(systemName: entry.meal.symbol)
                    .foregroundStyle(entry.meal.color)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(entry.name).font(.headline)
                Text(entry.meal.title).font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            Text("\(entry.calories) kcal").monospacedDigit()
            Menu {
                Button(action: onEdit) { Label("Edit", systemImage: "pencil") }
                Button(role: .destructive, action: onDelete) { Label("Delete", systemImage: "trash") }
            } label: {
                Image(systemName: "ellipsis.circle").imageScale(.large)
            }
        }
        .softCard(padding: 12)
    }
}

