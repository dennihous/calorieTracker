//
//  CalorieTrackerApp.swift
//  calorieTracker
//
//  Created by Sam Houston on 16/08/2025.
//
import SwiftUI

struct FoodEntry: Identifiable, Hashable, Codable {
    let id: UUID
    var date: Date
    var name: String
    var calories: Int
    var meal: MealType

    init(id: UUID = UUID(), date: Date, name: String, calories: Int, meal: MealType) {
        self.id = id
        self.date = date
        self.name = name
        self.calories = calories
        self.meal = meal
    }
}

enum MealType: String, CaseIterable, Codable, Identifiable {
    case breakfast, lunch, dinner, snack
    var id: String { rawValue }

    var title: String {
        switch self {
        case .breakfast: return "Breakfast"
        case .lunch: return "Lunch"
        case .dinner: return "Dinner"
        case .snack: return "Snack"
        }
    }

    var symbol: String {
        switch self {
        case .breakfast: return "sunrise"
        case .lunch: return "fork.knife.circle"
        case .dinner: return "moon.zzz"
        case .snack: return "takeoutbag.and.cup.and.straw"
        }
    }
}
