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
    @EnvironmentObject private var auth: AuthViewModel
    @Binding var selectedTab: AppTab

    @State private var monthOffset: Int = 0
    @State private var selectedDate: Date = Date()

    private var calendar: Calendar { var c = Calendar.current; c.timeZone = .current; return c }

    private var firstOfCurrentMonth: Date { calendar.date(from: calendar.dateComponents([.year, .month], from: Date()))! }
    private var firstOfDisplayedMonth: Date { calendar.date(byAdding: .month, value: monthOffset, to: firstOfCurrentMonth)! }
    private var daysInDisplayedMonth: Int { calendar.range(of: .day, in: .month, for: firstOfDisplayedMonth)!.count }

    private var monthTitle: String { let df = DateFormatter(); df.calendar = calendar; df.dateFormat = "LLLL yyyy"; return df.string(from: firstOfDisplayedMonth) }

    private var leadingBlankDays: Int {
        let weekdayOfFirst = calendar.component(.weekday, from: firstOfDisplayedMonth)
        let firstWeekday = calendar.firstWeekday
        return (weekdayOfFirst - firstWeekday + 7) % 7
    }

    private var weekdaySymbols: [String] {
        let symbols = calendar.shortWeekdaySymbols
        let start = calendar.firstWeekday - 1
        return Array(symbols[start...] + symbols[..<start])
    }

    var body: some View {
        NavigationStack {
            GeometryReader { proxy in
                let panelHeight = max(220, proxy.size.height * 0.36)

                VStack(spacing: UI.outerSpacing) {

                    // Month header
                    HStack {
                        Button { withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) { monthOffset -= 1 } } label: {
                            Image(systemName: "chevron.left")
                        }
                        Spacer()
                        Text(monthTitle).font(.title3.weight(.semibold))
                        Spacer()
                        Button { withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) { monthOffset += 1 } } label: {
                            Image(systemName: "chevron.right")
                        }
                    }
                    .softCard()

                    // Weekday labels
                    HStack {
                        ForEach(weekdaySymbols, id: \.self) { d in
                            Text(d).font(.caption).frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.horizontal, UI.outerSpacing)

                    // Calendar grid
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 7), spacing: 8) {
                        ForEach(0..<leadingBlankDays, id: \.self) { _ in Color.clear.frame(height: 52) }
                        ForEach(1...daysInDisplayedMonth, id: \.self) { day in
                            let date = calendar.date(byAdding: .day, value: day - 1, to: firstOfDisplayedMonth)!
                            DayCell(
                                date: date,
                                isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                                hasLog: store.hasEntries(on: date),
                                total: store.totalCalories(on: date)
                            )
                            .onTapGesture { withAnimation(.easeInOut(duration: 0.15)) { selectedDate = date } }
                        }
                    }
                    .padding(.horizontal, UI.outerSpacing)

                    VStack(alignment: .leading, spacing: 10) {
                        HStack(alignment: .firstTextBaseline) {
                            Text(formatted(selectedDate)).font(.headline)
                            Spacer()
                            HStack(spacing: 6) {
                                Image(systemName: "flame.fill")
                                Text("\(store.totalCalories(on: selectedDate)) kcal").bold().monospacedDigit()
                            }
                            .dangerPill()
                        }

                        Divider()

                        if store.entries(on: selectedDate).isEmpty {
                            VStack(spacing: 8) {
                                Image(systemName: "rectangle.and.pencil.and.ellipsis").font(.title2).foregroundStyle(.secondary)
                                Text("No entries for this day").foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {
                            ScrollView {
                                VStack(spacing: 12) {
                                    ForEach(store.entries(on: selectedDate)) { entry in
                                        EntryRow(entry: entry, onEdit: { startEditing(entry) }, onDelete: { store.remove(entry) })
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                            .scrollIndicators(.visible)
                        }
                    }
                    .softCard()
                    .frame(height: panelHeight)
                }
                .padding(.vertical, UI.outerSpacing)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .background(
                    LinearGradient(
                        colors: [Color(.systemGroupedBackground), Color(.secondarySystemGroupedBackground)],
                        startPoint: .top, endPoint: .bottom
                    ).ignoresSafeArea()
                )
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) { Text("Calendar").font(.title2.weight(.bold)) }
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button(role: .destructive) { auth.logout() } label: {
                            Label("Log Out", systemImage: "rectangle.portrait.and.arrow.right")
                        }
                    } label: {
                        Image(systemName: "person.crop.circle")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                            monthOffset = 0; selectedDate = Date()
                        }
                    } label: { Label("Today", systemImage: "target") }
                }
            }
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 8)
            }
        }
    }

    private func startEditing(_ entry: FoodEntry) { draft.load(from: entry); selectedTab = .log }
    private func formatted(_ date: Date) -> String { let df = DateFormatter(); df.calendar = calendar; df.dateStyle = .full; return df.string(from: date) }
}
