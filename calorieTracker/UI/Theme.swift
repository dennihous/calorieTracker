//
//  Theme.swift
//  calorieTracker
//
//  Created by Sam Houston on 16/08/2025.
//

import SwiftUI

enum Theme {
    static let accent = Color(hue: 0.58, saturation: 0.55, brightness: 0.72)

    static let bgTop    = Color(hue: 0.58, saturation: 0.10, brightness: 0.99)
    static let bgBottom = Color(hue: 0.58, saturation: 0.08, brightness: 0.95)

    static var bgGradient: LinearGradient {
        LinearGradient(colors: [bgTop, bgBottom], startPoint: .top, endPoint: .bottom)
    }
}
