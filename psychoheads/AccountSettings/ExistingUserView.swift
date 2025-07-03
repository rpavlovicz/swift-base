//
//  ExistingUserView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 2/2/25.
//

import SwiftUI
// Uncomment when ready to use Firebase
// import FirebaseAuth

final class SignInEmailViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage: String?
    
    func signIn(completion: @escaping (Bool) -> Void) {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter both email and password."
            completion(false)
            return
        }
        
        // Firebase authentication - uncomment when ready to use Firebase
        /*
        Task {
            do {
                let returnedUserData = try await AuthenticationManager.shared.signInUser(email: email, password: password)
                print("Successfully signed in")
                print(returnedUserData)
                errorMessage = nil
                completion(true)
                
            } catch {
                handleSignInError(error)
                completion(false)
            }
        }
        */
        
        // Template: Simulate authentication for testing
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if self.email == "test@example.com" && self.password == "password" {
                print("Template: Successfully signed in as \(self.email)")
                self.errorMessage = nil
                completion(true)
            } else {
                self.errorMessage = "Template: Invalid credentials. Use test@example.com / password"
                completion(false)
            }
        }
    }
    
    private func handleSignInError(_ error: Error) {
        // Firebase error handling - uncomment when ready to use Firebase
        /*
        if let authError = error as NSError? {
            let errorCode = AuthErrorCode.Code(rawValue: authError.code)
            switch errorCode {
            case .invalidEmail:
                errorMessage = "Email address in invalid. Please enter a valid email address."
            case .wrongPassword:
                errorMessage = "Incorrect password. Please try again."
            case .userNotFound:
                errorMessage = "No account found with this email. Please sign up first."
            case .tooManyRequests:
                errorMessage = "Too many login attempts. Try again later."
            case .networkError:
                errorMessage = "Network error. Please check your connection and try again."
            case .operationNotAllowed:
                errorMessage = "Sign-in is currently not enabled. Contact suppport."
            default:
                errorMessage = "An unknown error occurred. Please try again."
            }
        }
        */
        
        // Template: Simple error handling
        errorMessage = "Template: Authentication error occurred."
    }
    
    var isFormValid: Bool {
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}


struct ExistingUserView: View {

    @StateObject private var viewModel = SignInEmailViewModel()
    @EnvironmentObject var navigationStateManager: NavigationStateManager
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
