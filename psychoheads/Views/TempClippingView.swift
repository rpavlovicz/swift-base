//
//  TempClippingView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 6/27/25.
//

import SwiftUI

struct TempClippingView: View {
    
    @EnvironmentObject var sourceModel: SourceModel
    @EnvironmentObject var navigationStateManager: NavigationStateManager
    @Environment(\.managedObjectContext) private var managedObjectContext
    
    @State private var currentClippingIndex = 0
    
    // Specific clipping and source IDs to display
    private let targetClippingId1 = "EC1EDDD3-C6C3-4333-A94D-AF1D5BB2B8F4"
    private let targetClippingId2 = "F97A4F93-E2C0-443A-B8E9-8CDF62BE9AC8"
    private let targetSourceId = "0F9C6965-18AE-4139-9D2F-E0238C2FF675"
    
    // Computed properties to find the clippings and source
    private var targetClipping1: Clipping? {
        // Search through all sources in the SourceModel
        for source in sourceModel.sources {
            if let clipping = source.clippings.first(where: { $0.id == targetClippingId1 }) {
                return clipping
            }
        }
        return nil
    }
    
    private var targetClipping2: Clipping? {
        // Search through all sources in the SourceModel
        for source in sourceModel.sources {
            if let clipping = source.clippings.first(where: { $0.id == targetClippingId2 }) {
                return clipping
            }
        }
        return nil
    }
    
    private var targetSource: Source? {
        return sourceModel.sources.first { $0.id == targetSourceId }
    }
    
    // Get the specific clippings we want to display
    private var targetClippings: [Clipping] {
        var clippings: [Clipping] = []
        if let clipping1 = targetClipping1 {
            clippings.append(clipping1)
        }
        if let clipping2 = targetClipping2 {
            clippings.append(clipping2)
        }
        return clippings
    }
    
    var body: some View {
        VStack {
            if let source = targetSource, !targetClippings.isEmpty {
                // Found the clippings - display them using ClippingsSwipeView
                VStack {
                    // Show source info

                    
                    // Display the clippings
                    ClippingsSwipeView(clippings: targetClippings, currentIndex: $currentClippingIndex)
                        .environmentObject(sourceModel)
                        .environmentObject(navigationStateManager)
                        .environment(\.managedObjectContext, managedObjectContext)
                }
            } else {
                    // Clipping not found - show error message
                    VStack(spacing: 20) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 60))
                            .foregroundColor(.orange)
                        
                        Text("Clipping Not Found")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Clipping ID 1: \(targetClippingId1)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Text("Clipping ID 2: \(targetClippingId2)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Text("Source ID: \(targetSourceId)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        
                        Text("This clipping may not exist in the current data or may have been deleted.")
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                        
                        // Show available clippings count
                        Text("Available clippings: \(sourceModel.sources.flatMap { $0.clippings }.count)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        // Debug info
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Debug Info:")
                                .font(.caption)
                                .fontWeight(.bold)
                            Text("Sources loaded: \(sourceModel.sources.count)")
                                .font(.caption)
                            Text("Target source found: \(targetSource != nil ? "Yes" : "No")")
                                .font(.caption)
                            Text("Target clipping 1 found: \(targetClipping1 != nil ? "Yes" : "No")")
                                .font(.caption)
                            Text("Target clipping 2 found: \(targetClipping2 != nil ? "Yes" : "No")")
                                .font(.caption)
                            if let source = targetSource {
                                Text("Source clippings: \(source.clippings.count)")
                                    .font(.caption)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray5))
                        .cornerRadius(8)
                    }
                    .padding()
                }
            }
            .navigationTitle("Temp Clipping View")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        navigationStateManager.popBack()
                    }
                }
            }
    }
}

struct TempClippingView_Previews: PreviewProvider {
    static var previews: some View {
        TempClippingView()
            .environmentObject(SourceModel())
            .environmentObject(NavigationStateManager())
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
} 
