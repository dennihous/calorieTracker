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
        VStack(spacing: 4) {
            Text("\(calendar.component(.day, from: date))")
                .font(isSelected ? .body.weight(.bold) : .body)
                .frame(maxWidth: .infinity)
            Circle()
                .fill(Color.primary) // unified type
                .frame(width: 6, height: 6)
                .opacity(hasLog ? 0.9 : 0)
            if hasLog {
                Text("\(total)")
                    .font(.system(size: 10))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(8)
        .frame(height: 44)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(isSelected ? Color.accentColor.opacity(0.15) : Color.clear)
        )
    }
}
