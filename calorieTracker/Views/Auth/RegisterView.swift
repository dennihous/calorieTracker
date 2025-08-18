//
//  RegisterView.swift
//  calorieTracker
//
//  Created by Sam Houston on 17/08/2025.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var auth: AuthViewModel
    @FocusState private var focus: Field?
    enum Field { case email, password, confirm }

    var body: some View {
        VStack(spacing: 16) {
            Group {
                TextField("Email", text: $auth.email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .textFieldStyle(.roundedBorder)
                    .focused($focus, equals: .email)
                    .submitLabel(.next)
                    .onSubmit { focus = .password }

                SecureField("Password (6+)", text: $auth.password)
                    .textFieldStyle(.roundedBorder)
                    .focused($focus, equals: .password)
                    .submitLabel(.next)
                    .onSubmit { focus = .confirm }

                SecureField("Confirm Password", text: $auth.confirmPassword)
                    .textFieldStyle(.roundedBorder)
                    .focused($focus, equals: .confirm)
                    .submitLabel(.go)
                    .onSubmit { Task { await auth.register() } }
            }
            .softCard()

            if let msg = auth.errorMessage {
                Text(msg).foregroundStyle(.red).font(.footnote)
            }

            Button {
                Task { await auth.register() }
            } label: {
                HStack {
                    if auth.isLoading { ProgressView().tint(.white) }
                    Text("Create Account").bold()
                }
                .frame(maxWidth: .infinity, minHeight: 44)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(.horizontal)
        .safeAreaInset(edge: .bottom) { Color.clear.frame(height: 10) }
    }
}
