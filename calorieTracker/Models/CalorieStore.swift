//
//  CalorieStore.swift
//  calorieTracker
//
//  Created by Sam Houston on 16/08/2025.
//
import SwiftUI

final class CalorieStore: ObservableObject {
    @Published private(set) var entriesByDay: [Date: [FoodEntry]] = [:]

    private var calendar: Calendar {
        var c = Calendar.current
        c.timeZone = .current
        return c
    }

    private func dayKey(for date: Date) -> Date { calendar.startOfDay(for: date) }

    func add(_ entry: FoodEntry) {
        let key = dayKey(for: entry.date)
        var dayEntries = entriesByDay[key, default: []]
        dayEntries.append(entry)
        dayEntries.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        entriesByDay[key] = dayEntries
    }

    func remove(_ entry: FoodEntry) {
        let key = dayKey(for: entry.date)
        guard var dayEntries = entriesByDay[key] else { return }
        dayEntries.removeAll { $0.id == entry.id }
        if dayEntries.isEmpty { entriesByDay.removeValue(forKey: key) }
        else { entriesByDay[key] = dayEntries }
    }

    func replace(old: FoodEntry, with new: FoodEntry) {
        // If the date changed, move between days
        remove(old)
        add(new)
    }

    func entries(on date: Date) -> [FoodEntry] {
        entriesByDay[dayKey(for: date)] ?? []
    }

    func totalCalories(on date: Date) -> Int {
        entries(on: date).map { $0.calories }.reduce(0, +)
    }

    func hasEntries(on date: Date) -> Bool { !entries(on: date).isEmpty }
}

final class EntryDraft: ObservableObject {
    @Published var date: Date = Date()
    @Published var meal: MealType = .breakfast
    @Published var name: String = ""
    @Published var calories: Int? = nil
    @Published var editingEntry: FoodEntry? = nil

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

enum AppTab: Hashable { case log, calendar }
