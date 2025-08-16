//
//  DayCell.swift
//  calorieTracker
//
//  Created by Sam Houston on 16/08/2025.
//
import SwiftUI

struct DayCell: View {
    let date: Date
    let isSelected: Bool
    let hasLog: Bool
    let total: Int

    private var calendar: Calendar { Calendar.current }

    var body: some View {
        VStack(spacing: 6) {
            Text("\(calendar.component(.day, from: date))")
                .font(isSelected ? .body.weight(.bold) : .body)
                .frame(maxWidth: .infinity)

            // Unified type to avoid .primary vs .clear mismatch
            Circle()
                .fill(Color.primary)
                .frame(width: 6, height: 6)
                .opacity(hasLog ? 0.9 : 0)

            if hasLog {
                Text("\(total)")
                    .font(.system(size: 10))
                    .foregroundStyle(.secondary)
                    .monospacedDigit()
            }
        }
        .padding(10)
        .frame(height: 52)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(isSelected ? Color.accentColor.opacity(0.12) : Color.clear)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .strokeBorder(isSelected ? Color.accentColor : Color.clear, lineWidth: 1)
        )
    }
}

