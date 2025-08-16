//
//  CalendarTab.swift
//  calorieTracker
//
//  Created by Sam Houston on 16/08/2025.
//
import SwiftUI

struct CalendarTab: View {
    @EnvironmentObject private var store: CalorieStore
    @EnvironmentObject private var draft: EntryDraft
    @Binding var selectedTab: AppTab

    @State private var monthOffset: Int = 0
    @State private var selectedDate: Date = Date()

    private var calendar: Calendar {
        var c = Calendar.current
        c.timeZone = .current
        return c
    }

    private var firstOfCurrentMonth: Date {
        calendar.date(from: calendar.dateComponents([.year, .month], from: Date()))!
    }

    private var firstOfDisplayedMonth: Date {
        calendar.date(byAdding: .month, value: monthOffset, to: firstOfCurrentMonth)!
    }

    private var daysInDisplayedMonth: Int {
        calendar.range(of: .day, in: .month, for: firstOfDisplayedMonth)!.count
    }

    private var monthTitle: String {
        let df = DateFormatter()
        df.calendar = calendar
        df.dateFormat = "LLLL yyyy"
        return df.string(from: firstOfDisplayedMonth)
    }

    private var leadingBlankDays: Int {
        let weekdayOfFirst = calendar.component(.weekday, from: firstOfDisplayedMonth)
        let firstWeekday = calendar.firstWeekday
        return (weekdayOfFirst - firstWeekday + 7) % 7
    }

    private var weekdaySymbols: [String] {
        let symbols = calendar.shortWeekdaySymbols // starts with Sunday
        let start = calendar.firstWeekday - 1 // 0-indexed
        return Array(symbols[start...] + symbols[..<start])
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                // Month header
                HStack {
                    Button { monthOffset -= 1 } label: { Image(systemName: "chevron.left") }
                    Spacer()
                    Text(monthTitle).font(.headline)
                    Spacer()
                    Button { monthOffset += 1 } label: { Image(systemName: "chevron.right") }
                }
                .padding(.horizontal)

                // Weekday labels
                HStack {
                    ForEach(weekdaySymbols, id: \.self) { d in
                        Text(d)
                            .font(.caption)
                            .frame(maxWidth: .infinity)
                    }
                }

                // Calendar grid
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 6), count: 7), spacing: 6) {
                    ForEach(0..<leadingBlankDays, id: \.self) { _ in
                        Color.clear.frame(height: 44)
                    }
                    ForEach(1...daysInDisplayedMonth, id: \.self) { day in
                        let date = calendar.date(byAdding: .day, value: day - 1, to: firstOfDisplayedMonth)!
                        DayCell(
                            date: date,
                            isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                            hasLog: store.hasEntries(on: date),
                            total: store.totalCalories(on: date)
                        )
                        .onTapGesture { selectedDate = date }
                    }
                }
                .padding(.horizontal)

                // Selected day summary
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(formatted(selectedDate)).font(.headline)
                        Spacer()
                        HStack(spacing: 6) {
                            Image(systemName: "flame.fill")
                            Text("\(store.totalCalories(on: selectedDate)) kcal").bold()
                        }
                    }

                    if store.entries(on: selectedDate).isEmpty {
                        VStack(spacing: 8) {
                            Image(systemName: "rectangle.and.pencil.and.ellipsis")
                                .font(.title2)
                                .foregroundStyle(.secondary)
                            Text("No entries for this day").foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                    } else {
                        VStack(spacing: 0) {
                            ForEach(store.entries(on: selectedDate)) { entry in
                                HStack {
                                    Image(systemName: entry.meal.symbol)
                                    VStack(alignment: .leading) {
                                        Text(entry.name)
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
                                .padding(.vertical, 6)
                                Divider()
                            }
                        }
                    }
                }
                .padding()
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal)

                Spacer(minLength: 0)
            }
            .navigationTitle("Calendar")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        monthOffset = 0
                        selectedDate = Date()
                    } label: { Label("Today", systemImage: "target") }
                }
            }
        }
    }

    private func startEditing(_ entry: FoodEntry) {
        draft.load(from: entry)
        selectedTab = .log
    }

    private func formatted(_ date: Date) -> String {
        let df = DateFormatter()
        df.calendar = calendar
        df.dateStyle = .full
        return df.string(from: date)
    }
}
