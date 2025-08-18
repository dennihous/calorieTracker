//
//  MealType.swift
//  calorieTracker
//
//  Created by Sam Houston on 16/08/2025.
//

import SwiftUI

extension MealType {
    var color: Color {
        switch self {
        case .breakfast: return Color(hue: 0.10, saturation: 0.70, brightness: 0.95)
        case .lunch:     return Color(hue: 0.33, saturation: 0.55, brightness: 0.80)
        case .dinner:    return Color(hue: 0.62, saturation: 0.55, brightness: 0.75)
        case .snack:     return Color(hue: 0.90, saturation: 0.45, brightness: 0.95)
        }
    }
}
