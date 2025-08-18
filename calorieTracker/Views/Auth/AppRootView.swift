//
//  AppRootView.swift
//  calorieTracker
//
//  Created by Sam Houston on 17/08/2025.
//

import SwiftUI

struct AppRootView: View {
    @StateObject private var auth = AuthViewModel()

    var body: some View {
        Group {
            if auth.isAuthenticated {
                ContentView()
            } else {
                AuthFlowView()
            }
        }
        .environmentObject(auth)
        .tint(Theme.accent)
        .background(Theme.bgGradient.ignoresSafeArea())
    }
}


private struct ContentViewWrapper: View {
    @ObservedObject var store: CalorieStore
    @ObservedObject var draft: EntryDraft
    @Binding var selectedTab: AppTab

    var body: some View {
        TabView(selection: $selectedTab) {
            LogView()
                .environmentObject(store)
                .environmentObject(draft)
                .tabItem { Label("Log", systemImage: "plus.circle") }
                .tag(AppTab.log)

            CalendarTab(selectedTab: $selectedTab)
                .environmentObject(store)
                .environmentObject(draft)
                .tabItem { Label("Calendar", systemImage: "calendar") }
                .tag(AppTab.calendar)
        }
    }
}

private struct AuthFlowView: View {
    @EnvironmentObject var auth: AuthViewModel
    @State private var mode: Mode = .login
    enum Mode { case login, register }

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Picker("", selection: $mode) {
                    Text("Login").tag(Mode.login)
                    Text("Register").tag(Mode.register)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                if mode == .login {
                    LoginView()
                } else {
                    RegisterView()
                }

                Spacer(minLength: 0)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(mode == .login ? "Welcome Back" : "Create Account")
                        .font(.title2.weight(.bold))
                }
            }
        }
    }
}
