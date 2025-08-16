//
//  ContentView.swift
//  calorieTracker
//
//  Created by Sam Houston on 09/08/2025.
//

import SwiftUI

enum AppTab: Hashable { case log, calendar }

struct ContentView: View {
    @StateObject private var store = CalorieStore()
    @StateObject private var draft = EntryDraft()
    @State private var selectedTab: AppTab = .log

    var body: some View {
        TabView(selection: $selectedTab) {
            LogView()
                .environmentObject(store)
                .environmentObject(draft)
                .tabItem { Label("Log", systemImage: "plus.circle") }
                .tag(AppTab.log)
                .background(Theme.bgGradient.ignoresSafeArea())

            CalendarTab(selectedTab: $selectedTab)
                .environmentObject(store)
                .environmentObject(draft)
                .tabItem { Label("Calendar", systemImage: "calendar") }
                .tag(AppTab.calendar)
                .background(Theme.bgGradient.ignoresSafeArea())
        }
        .tint(Theme.accent)
    }
}


#Preview {
    ContentView()
}
