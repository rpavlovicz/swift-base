//
//  AccountSettings.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 1/12/25.
//

import SwiftUI
import FirebaseAuth
import CoreData

final class SettingsViewModel: ObservableObject {
    
    @Published var userName: String? = nil
    @Published var cacheUsage: String = ""
    @Published var showingClearCacheAlert = false
    
    init() {
        fetchCurrentUser()
        updateCacheUsage()
    }
    
    func fetchCurrentUser() {

        if let user = AuthenticationManager.shared.getCurrentUser() {
            DispatchQueue.main.async {
                self.userName = user.email
                print("User is signed in as \(self.userName ?? "Unknown")")
            }
        } else {
            self.userName = nil
            print("user is not signed in")
        }
    }

    
    func signOut() {

        do {
            try AuthenticationManager.shared.signOut()
            DispatchQueue.main.async {
                self.userName = nil
            }
            print("User signed out.")
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }

        
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

    func signIn(completion: @escaping (Bool) -> Void) {
        // Implementation of signIn function
    }
}

struct AccountSettingsView: View {
    
    @StateObject private var viewModel = SettingsViewModel()
    @EnvironmentObject var sourceModel: SourceModel
    @EnvironmentObject var navigationStateManager: NavigationStateManager
    @Environment(\.managedObjectContext) private var managedObjectContext
    @State private var showingDataManagementAlert = false
    @State private var dataManagementMessage = ""

    var body: some View {
        List {
            authenticationSection
            cacheSection
            dataManagementSection
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
        .alert("Data Management", isPresented: $showingDataManagementAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Update Core Data", role: .destructive) {
                updateCoreDataFromFirebase()
            }
        } message: {
            Text("This will update Core Data statistics from your Firebase data. This may take a moment.")
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
                    // Reload sources after logout
                    sourceModel.reloadSources()
                }
                .foregroundColor(.red)
            } else {
                NavigationLink("Sign Up", value: SelectionState.newUser)
                    .simultaneousGesture(TapGesture().onEnded {
                        // Refresh sources for new user
                        sourceModel.getSources()
                    })
                NavigationLink("Sign In", value: SelectionState.existingUser)
                    .simultaneousGesture(TapGesture().onEnded {
                        // Refresh sources for existing user
                        sourceModel.getSources()
                    })
            }
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
    
    // MARK: - Data Management Section
    private var dataManagementSection: some View {
        Section(header: Text("Data Management")) {
            Button(action: {
                showingDataManagementAlert = true
            }) {
                Text("Manage Data")
                    .foregroundColor(.blue)
            }
        }
    }
    
    // MARK: - Data Management Functions
    private func updateCoreDataFromFirebase() {
        print("Updating Core Data from Firebase...")
        
        // Clear existing HeadName data first
        let headNameFetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "HeadName")
        let headNameDeleteRequest = NSBatchDeleteRequest(fetchRequest: headNameFetchRequest)
        
        do {
            try managedObjectContext.execute(headNameDeleteRequest)
            print("Cleared existing HeadName data")
        } catch {
            print("Error clearing HeadName data: \(error)")
        }
        
        // Clear existing ClippingTag data first
        let clippingTagFetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "ClippingTag")
        let clippingTagDeleteRequest = NSBatchDeleteRequest(fetchRequest: clippingTagFetchRequest)
        
        do {
            try managedObjectContext.execute(clippingTagDeleteRequest)
            print("Cleared existing ClippingTag data")
        } catch {
            print("Error clearing ClippingTag data: \(error)")
        }
        
        // Clear existing SourceName data first
        let sourceNameFetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "SourceName")
        let sourceNameDeleteRequest = NSBatchDeleteRequest(fetchRequest: sourceNameFetchRequest)
        
        do {
            try managedObjectContext.execute(sourceNameDeleteRequest)
            print("Cleared existing SourceName data")
        } catch {
            print("Error clearing SourceName data: \(error)")
        }
        
        // Update HeadName statistics
        var headNameCountDictionary: [String: Int] = [:]
        
        for clipping in sourceModel.clippings {
            if (clipping.isHead && !clipping.isBody) {
                let headNameString = clipping.name
                if let count = headNameCountDictionary[headNameString] {
                    headNameCountDictionary[headNameString] = count + 1
                } else {
                    headNameCountDictionary[headNameString] = 1
                }
            }
        }
        print("Head names found: \(headNameCountDictionary)")
        
        // Update ClippingTag statistics
        var tagCountDictionary: [String: Int] = [:]
        
        for clipping in sourceModel.clippings {
            for tag in clipping.tags {
                if let count = tagCountDictionary[tag] {
                    tagCountDictionary[tag] = count + 1
                } else {
                    tagCountDictionary[tag] = 1
                }
            }
        }
        print("Tags found: \(tagCountDictionary)")
        
        // Update SourceName statistics
        var sourceNameCountDictionary: [String: Int] = [:]
        
        for source in sourceModel.sources {
            let title = source.title
            if let count = sourceNameCountDictionary[title] {
                sourceNameCountDictionary[title] = count + 1
            } else {
                sourceNameCountDictionary[title] = 1
            }
        }
        print("Source names found: \(sourceNameCountDictionary)")
        
        // Create new HeadName entities
        for (name, count) in headNameCountDictionary {
            let newHeadName = HeadName(context: self.managedObjectContext)
            newHeadName.name = name
            newHeadName.count = Int64(count)
        }
        
        // Create new ClippingTag entities
        for (tag, count) in tagCountDictionary {
            let newTag = ClippingTag(context: self.managedObjectContext)
            newTag.tagString = tag
            newTag.count = Int64(count)
        }
        
        // Create new SourceName entities
        for (name, count) in sourceNameCountDictionary {
            let newSourceName = SourceName(context: self.managedObjectContext)
            newSourceName.nameString = name
            newSourceName.count = Int64(count)
        }
        
        // Save all changes
        do {
            try self.managedObjectContext.save()
            print("Core Data updated successfully")
            dataManagementMessage = "Core Data updated successfully with \(headNameCountDictionary.count) head names, \(tagCountDictionary.count) tags, and \(sourceNameCountDictionary.count) source names."
        } catch {
            print("Error saving Core Data: \(error)")
            dataManagementMessage = "Error updating Core Data: \(error.localizedDescription)"
        }
    }
}

struct AccountSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AccountSettingsView()
                .environmentObject(SourceModel())
                .environmentObject(NavigationStateManager())
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        }
    }
}
