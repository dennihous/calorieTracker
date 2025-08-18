//
//  LoginView.swift
//  calorieTracker
//
//  Created by Sam Houston on 17/08/2025.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var auth: AuthViewModel
    @FocusState private var focus: Field?
    enum Field { case email, password }

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

                SecureField("Password", text: $auth.password)
                    .textFieldStyle(.roundedBorder)
                    .focused($focus, equals: .password)
                    .submitLabel(.go)
                    .onSubmit { Task { await auth.login() } }
            }
            .softCard()

            if let msg = auth.errorMessage {
                Text(msg).foregroundStyle(.red).font(.footnote)
            }

            Button {
                Task { await auth.login() }
            } label: {
                HStack {
                    if auth.isLoading { ProgressView().tint(.white) }
                    Text("Log In").bold()
                }
                .frame(maxWidth: .infinity, minHeight: 44)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(.horizontal)
        .safeAreaInset(edge: .bottom) { Color.clear.frame(height: 10) }
    }
}
