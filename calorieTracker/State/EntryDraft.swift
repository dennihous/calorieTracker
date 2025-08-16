//
//  Untitled.swift
//  calorieTracker
//
//  Created by Sam Houston on 16/08/2025.
//

import Foundation
import Combine

final class EntryDraft: ObservableObject {
    @Published var date: Date = Date()
    @Published var meal: MealType = .breakfast
    @Published var name: String = ""
    @Published var calories: Int? = nil
    @Published var editingEntry: FoodEntry? = nil   // non-nil → editing

    var isEditing: Bool { editingEntry != nil }

    func load(from entry: FoodEntry) {
        date = entry.date
        meal = entry.meal
        name = entry.name
        calories = entry.calories
        editingEntry = entry
    }

    func clear() {
        date = Date()
        meal = .breakfast
        name = ""
        calories = nil
        editingEntry = nil
    }
}
