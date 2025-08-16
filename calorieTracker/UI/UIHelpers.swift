//
//  UIHelpers.swift
//  calorieTracker
//
//  Created by Sam Houston on 16/08/2025.
//

import SwiftUI

enum UI {
    static let corner: CGFloat = 16
    static let innerSpacing: CGFloat = 12
    static let outerSpacing: CGFloat = 16
}

extension View {
    func softCard(padding: CGFloat = UI.outerSpacing) -> some View {
        self
            .padding(padding)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: UI.corner, style: .continuous))
            .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 4)
    }

    func pillBackground() -> some View {
        self
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                Capsule(style: .continuous)
                    .fill(Color.accentColor.opacity(0.12))
            )
    }
}
