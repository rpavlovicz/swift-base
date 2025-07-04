//
//  ExistingUserView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 2/2/25.
//

import SwiftUI
import FirebaseAuth

final class SignInEmailViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage: String?
    
    func signIn(completion: @escaping (Bool) -> Void) {
        guard !email.isEmpty, !password.isEmpty else {
            DispatchQueue.main.async {
                self.errorMessage = "Please enter both email and password."
            }
            completion(false)
            return
        }
        
        Task {
            do {
                let returnedUserData = try await AuthenticationManager.shared.signInUser(email: email, password: password)
                DispatchQueue.main.async {
                    print("Successfully signed in")
                    print(returnedUserData)
                    self.errorMessage = nil
                }
                completion(true)
                
            } catch {
                handleSignInError(error)
                completion(false)
            }
        }
        
    }
    
    private func handleSignInError(_ error: Error) {
        if let authError = error as NSError? {
            let errorCode = AuthErrorCode(rawValue: authError.code)
            DispatchQueue.main.async {
                switch errorCode {
                case .invalidEmail:
                    self.errorMessage = "Email address in invalid. Please enter a valid email address."
                case .wrongPassword:
                    self.errorMessage = "Incorrect password. Please try again."
                case .userNotFound:
                    self.errorMessage = "No account found with this email. Please sign up first."
                case .tooManyRequests:
                    self.errorMessage = "Too many login attempts. Try again later."
                case .networkError:
                    self.errorMessage = "Network error. Please check your connection and try again."
                case .operationNotAllowed:
                    self.errorMessage = "Sign-in is currently not enabled. Contact suppport."
                default:
                    self.errorMessage = "An unknown error occurred. Please try again."
                }
            }
        }
    }
    
    var isFormValid: Bool {
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}


struct ExistingUserView: View {

    @StateObject private var viewModel = SignInEmailViewModel()
    @EnvironmentObject var navigationStateManager: NavigationStateManager
    @EnvironmentObject var sourceModel: SourceModel
    @State private var isPasswordVisible = false // Toggle for main password
    
    var body: some View {
        VStack(spacing: 20) {
            // Template notice
            VStack(spacing: 8) {
                Text("Template Sign In")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Use test@example.com / password")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.bottom)
            
            TextField("Email", text: $viewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
            
            ZStack(alignment: .trailing) {
                if isPasswordVisible {
                    TextField("Password", text: $viewModel.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                } else {
                    SecureField("Password", text: $viewModel.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                Button(action: {
                    isPasswordVisible.toggle()
                }) {
                    Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                        .foregroundColor(.gray)
                        .padding(.trailing, 8)
                }
            }
            
            Button {
                viewModel.signIn { success in
                    if success {
                        DispatchQueue.main.async {
                            sourceModel.reloadSources() // Load user's data after successful login
                            navigationStateManager.popBack() // Ensure navigation update is on the main thread
                        }
                    } else {
                        print("Sign in failed.")
                    }
                }
            } label: {
                Text("Sign In")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(viewModel.isFormValid ? Color.blue : Color.gray)
                    .cornerRadius(10)
            }
            .disabled(!viewModel.isFormValid) // Disable the button if the form is invalid
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .font(.caption)
            }
            
            Spacer()
        } // VStack
        .padding()
        .navigationTitle("Sign In")
    }
}

//#Preview {
//    ExistingUserView()
//}
