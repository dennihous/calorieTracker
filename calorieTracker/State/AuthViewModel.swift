//
//  AuthViewModel.swift
//  calorieTracker
//
//  Created by Sam Houston on 17/08/2025.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    @AppStorage("authToken") private var storedToken: String?
    @Published private(set) var token: AuthToken?

    var isAuthenticated: Bool { token != nil }

    private let service: AuthService

    init(service: AuthService = MockAuthService()) {
        self.service = service
        if let t = storedToken { token = AuthToken(value: t) }
    }

    func login() async {
        errorMessage = nil; isLoading = true
        defer { isLoading = false }
        do {
            let t = try await service.login(email: email.trimmingCharacters(in: .whitespaces),
                                            password: password)
            token = t
            storedToken = t.value
        } catch {
            errorMessage = (error as NSError).localizedDescription
        }
    }

    func register() async {
        errorMessage = nil; isLoading = true
        defer { isLoading = false }
        guard password == confirmPassword else {
            errorMessage = "Passwords don’t match"
            return
        }
        do {
            let t = try await service.register(email: email.trimmingCharacters(in: .whitespaces),
                                               password: password)
            token = t
            storedToken = t.value
        } catch {
            errorMessage = (error as NSError).localizedDescription
        }
    }

    func logout() {
        token = nil
        storedToken = nil
        email = ""; password = ""; confirmPassword = ""
        Task { await service.logout() }
    }
}
