//
//  AuthService.swift
//  calorieTracker
//
//  Created by Sam Houston on 17/08/2025.
//

import Foundation

struct AuthToken: Codable, Equatable {
    let value: String
}

protocol AuthService {
    func login(email: String, password: String) async throws -> AuthToken
    func register(email: String, password: String) async throws -> AuthToken
    func logout() async
}

final class MockAuthService: AuthService {
    func login(email: String, password: String) async throws -> AuthToken {
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5s
        guard email.contains("@"), password.count >= 6 else {
            throw NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "Invalid email or password"])
        }
        return AuthToken(value: "mock-\(UUID().uuidString)")
    }

    func register(email: String, password: String) async throws -> AuthToken {
        try await Task.sleep(nanoseconds: 600_000_000)
        guard email.contains("@"), password.count >= 6 else {
            throw NSError(domain: "Auth", code: 400, userInfo: [NSLocalizedDescriptionKey: "Use a valid email and 6+ character password"])
        }
        return AuthToken(value: "mock-\(UUID().uuidString)")
    }

    func logout() async {}
}
