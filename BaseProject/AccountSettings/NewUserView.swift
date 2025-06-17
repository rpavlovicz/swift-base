//
//  NewUserView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 1/12/25.
//

import SwiftUI
import FirebaseAuth

final class SignUpEmailViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var errorMessage: String?
    
    func signUp(completion: @escaping (Bool) -> Void) {
        guard !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            errorMessage = "Please enter email and both password fields."
            completion(false)
            return
        }
        
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            completion(false)
            return
        }
        
        Task {
            do {
                let returnedUserData = try await AuthenticationManager.shared.createUser(email: email, password: password)
                print("Successfully signed up!")
                print(returnedUserData)
                errorMessage = nil
                completion(true)
                
            } catch {
                handleSignUpError(error)
                completion(false)
            }
        }
    
    }
    
    private func handleSignUpError(_ error: Error) {
        if let authError = error as NSError? {
            let errorCode = AuthErrorCode.Code(rawValue: authError.code)
            switch errorCode {
            case .emailAlreadyInUse:
                errorMessage = "This email address is already in use. Please use a different email or use sign-in function."
            case .invalidEmail:
                errorMessage = "Email address in invalid. Please enter a valid email address."
            case .weakPassword:
                errorMessage = "The selected password is too weak. Please try again."
            default:
                errorMessage = "An unknown error occurred. Please try again."
            }
        }
    }
    
    var isFormValid: Bool {
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !confirmPassword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        password == confirmPassword // Ensure passwords match
    }
}

struct NewUserView: View {
    
    @StateObject private var viewModel = SignUpEmailViewModel()
    @EnvironmentObject var navigationStateManager: NavigationStateManager
    @State private var isPasswordVisible = false // State to toggle password visibility
    @State private var isConfirmPasswordVisible = false // Toggle for confirmation password
    
    var body: some View {
        VStack {
            Text("Sign up with email:")
            
            TextField("Email", text: $viewModel.email)
                .padding()
                .background(Color.gray.opacity(0.3))
                .cornerRadius(10)
            
            // Password Field with Eye Icon
            ZStack(alignment: .trailing) {
                if isPasswordVisible {
                    TextField("Password", text: $viewModel.password)
                        .padding()
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(10)
                } else {
                    SecureField("Password", text: $viewModel.password)
                        .padding()
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(10)
                }
                
                Button(action: {
                    isPasswordVisible.toggle() // Toggle visibility state
                }) {
                    Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            
            // Confirm Password Field
            ZStack(alignment: .trailing) {
                if isConfirmPasswordVisible {
                    TextField("Confirm Password", text: $viewModel.confirmPassword)
                        .padding()
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(10)
                } else {
                    SecureField("Confirm Password", text: $viewModel.confirmPassword)
                        .padding()
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(10)
                }
                
                Button(action: {
                    isConfirmPasswordVisible.toggle()
                }) {
                    Image(systemName: isConfirmPasswordVisible ? "eye" : "eye.slash")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            
            Button {
                viewModel.signUp { success in
                    if success {
                        DispatchQueue.main.async {
                            navigationStateManager.popBack() // Ensure navigation update is on the main thread
                        }
                    } else {
                        print("Sign-up failed.")
                    }
                }
            } label: {
                Text("Submit")
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
            }
            
        } // VStack
        .padding()
    }
}

//#Preview {
//    NewUserView()
//}
