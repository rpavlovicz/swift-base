//
//  AccountSettings.swift
//  BaseProject
//
//  Created by Ryan Pavlovicz on 1/12/25.
//

import SwiftUI
// Uncomment when ready to use Firebase
// import FirebaseAuth

final class SettingsViewModel: ObservableObject {
    
    @Published var userName: String? = nil
    @Published var cacheUsage: String = ""
    @Published var showingClearCacheAlert = false
    
    init() {
        fetchCurrentUser()
        updateCacheUsage()
    }
    
    func fetchCurrentUser() {
        // Firebase authentication - uncomment when ready to use Firebase
        /*
        if let user = AuthenticationManager.shared.getCurrentUser() {
            DispatchQueue.main.async {
                self.userName = user.email
                print("User is signed in as \(self.userName ?? "Unknown")")
            }
        } else {
            self.userName = nil
            print("user is not signed in")
        }
        */
        
        // Template: Simulate user state for testing
        self.userName = "test@example.com"
        print("Template: User is signed in as \(self.userName ?? "Unknown")")
    }

    
    func signOut() {
        // Firebase sign out - uncomment when ready to use Firebase
        /*
        do {
            try AuthenticationManager.shared.signOut()
            DispatchQueue.main.async {
                self.userName = nil
            }
            print("User signed out.")
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
        */
        
        // Template: Simulate sign out for testing
        DispatchQueue.main.async {
            self.userName = nil
        }
        print("Template: User signed out.")
    }
    
    func updateCacheUsage() {
        cacheUsage = CacheManager.shared.totalCacheUsage()
    }
    
    func clearCache() {
        CacheManager.shared.clearCache()
        updateCacheUsage()
    }
}

struct AccountSettingsView: View {
    
    @StateObject private var viewModel = SettingsViewModel()
    @EnvironmentObject var sourceModel: SourceModel
    @EnvironmentObject var navigationStateManager: NavigationStateManager

    var body: some View {
        List {
            authenticationSection
            cacheSection
        }
        .navigationTitle("Account Settings")
        .onAppear {
            viewModel.fetchCurrentUser() // Refresh user state when navigating to the screen
        }
        .alert("Clear Cache", isPresented: $viewModel.showingClearCacheAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Clear", role: .destructive) {
                viewModel.clearCache()
            }
        } message: {
            Text("This will clear all cached images. Images will be re-downloaded when needed.")
        }
    }
    
    // MARK: - Authentication Section
    private var authenticationSection: some View {
        Section(header: Text("Authentication")) {
            if let userName = viewModel.userName {
                Text("Logged in as: \(userName)")
                    .font(.headline)
                    .foregroundColor(.green)
                
                Button("Log Out") {
                    viewModel.signOut()
                    // Template: Reset to sample data instead of reloading sources
                    sourceModel.resetToSampleData()
                }
                .foregroundColor(.red)
            } else {
                NavigationLink("Sign Up", value: SelectionState.newUser)
                    .simultaneousGesture(TapGesture().onEnded {
                        // Template: Reset to sample data instead of reloading sources
                        sourceModel.resetToSampleData()
                    })
                NavigationLink("Sign In", value: SelectionState.existingUser)
                    .simultaneousGesture(TapGesture().onEnded {
                        // Template: Reset to sample data instead of reloading sources
                        sourceModel.resetToSampleData()
                    })            }
        }
    }
    
    // MARK: - Cache Section
    private var cacheSection: some View {
        Section(header: Text("Usage")) {
            HStack {
                Text("Cache Usage")
                Spacer()
                Text(viewModel.cacheUsage)
                    .foregroundColor(.gray)
            }
            
            Button(action: {
                viewModel.showingClearCacheAlert = true
            }) {
                Text("Clear Cache")
                    .foregroundColor(.red)
            }
        }
    }
}

//struct AccountSettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack {
//            AccountSettingsView()
//        }
//    }
//}
