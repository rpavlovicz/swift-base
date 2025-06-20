//
//  MainButtonRow.swift
//  BaseProject
//
//  Created by Ryan Pavlovicz on 3/24/23.
//

import SwiftUI

struct MainButtonRow: View {

    @EnvironmentObject var sourceModel: SourceModel
    @EnvironmentObject var navigationStateManager: NavigationStateManager
    @State private var showingMoreOptions = false
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @State private var isLandscape: Bool = false
    
    // Determine if we should show all buttons in one row
    private var shouldShowAllButtons: Bool {
        return isLandscape && UIDevice.current.userInterfaceIdiom == .pad
    }
    
    // All buttons in a single row
    var allButtons: some View {
        HStack {
            Spacer()
            
            // View One
            NavigationLink(value: SelectionState.viewOne, label: {
                VStack(spacing: 4) {
                    Image(systemName: "1.circle.fill")
                        .font(.system(size: 26, weight: .regular))
                    Text("View 1")
                        .font(.caption2)
                }
                .padding(8)
            })
            
            Spacer()
            
            // View Two
            NavigationLink(value: SelectionState.viewTwo, label: {
                VStack(spacing: 4) {
                    Image(systemName: "2.circle.fill")
                        .font(.system(size: 26, weight: .regular))
                    Text("View 2")
                        .font(.caption2)
                }
                .padding(8)
            })
            
            Spacer()
            
            // View Three
            NavigationLink(value: SelectionState.viewThree, label: {
                VStack(spacing: 4) {
                    Image(systemName: "3.circle.fill")
                        .font(.system(size: 26, weight: .regular))
                    Text("View 3")
                        .font(.caption2)
                }
                .padding(8)
            })
            
            Spacer()
            
            // Settings
            NavigationLink(value: SelectionState.accountSettings, label: {
                VStack(spacing: 4) {
                    Image(systemName: "gear")
                        .font(.system(size: 26, weight: .regular))
                    Text("Settings")
                        .font(.caption2)
                }
                .padding(8)
            })
            
            Spacer()
            
            // Add Sample Shape
            Button(action: {
                sourceModel.addSampleShape()
            }) {
                VStack(spacing: 4) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 26, weight: .regular))
                    Text("Add Shape")
                        .font(.caption2)
                }
                .padding(8)
            }
            
            Spacer()
            
            // Reset Shapes
            Button(action: {
                sourceModel.resetToSampleData()
            }) {
                VStack(spacing: 4) {
                    Image(systemName: "arrow.clockwise.circle.fill")
                        .font(.system(size: 26, weight: .regular))
                    Text("Reset")
                        .font(.caption2)
                }
                .padding(8)
            }
            
            Spacer()
            
            // Help
            Button(action: {
                // Template: Add help functionality later
                print("Help button tapped")
            }) {
                VStack(spacing: 4) {
                    Image(systemName: "questionmark.circle.fill")
                        .font(.system(size: 26, weight: .regular))
                    Text("Help")
                        .font(.caption2)
                }
                .padding(8)
            }
            
            Spacer()
        }
    }
    
    // Primary buttons (shown by default on smaller screens)
    var primaryButtons: some View {
        HStack {
            Spacer()
            
            // View One
            NavigationLink(value: SelectionState.viewOne, label: {
                VStack(spacing: 4) {
                    Image(systemName: "1.circle.fill")
                        .font(.system(size: 26, weight: .regular))
                    Text("View 1")
                        .font(.caption2)
                }
                .padding(8)
            })
            
            Spacer()
            
            // View Two
            NavigationLink(value: SelectionState.viewTwo, label: {
                VStack(spacing: 4) {
                    Image(systemName: "2.circle.fill")
                        .font(.system(size: 26, weight: .regular))
                    Text("View 2")
                        .font(.caption2)
                }
                .padding(8)
            })
            
            Spacer()
            
            // View Three
            NavigationLink(value: SelectionState.viewThree, label: {
                VStack(spacing: 4) {
                    Image(systemName: "3.circle.fill")
                        .font(.system(size: 26, weight: .regular))
                    Text("View 3")
                        .font(.caption2)
                }
                .padding(8)
            })
            
            Spacer()
            
            // Settings
            NavigationLink(value: SelectionState.accountSettings, label: {
                VStack(spacing: 4) {
                    Image(systemName: "gear")
                        .font(.system(size: 26, weight: .regular))
                    Text("Settings")
                        .font(.caption2)
                }
                .padding(8)
            })
            
            Spacer()
        }
    }
    
    // Secondary buttons (shown when More is pressed on smaller screens)
    var secondaryButtons: some View {
        HStack {
            Spacer()
            
            // Add Sample Shape
            Button(action: {
                sourceModel.addSampleShape()
            }) {
                VStack(spacing: 4) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 26, weight: .regular))
                    Text("Add Shape")
                        .font(.caption2)
                }
                .padding(8)
            }
            
            Spacer()
            
            // Reset Shapes
            Button(action: {
                sourceModel.resetToSampleData()
            }) {
                VStack(spacing: 4) {
                    Image(systemName: "arrow.clockwise.circle.fill")
                        .font(.system(size: 26, weight: .regular))
                    Text("Reset")
                        .font(.caption2)
                }
                .padding(8)
            }
            
            Spacer()
            
            // Help
            Button(action: {
                // Template: Add help functionality later
                print("Help button tapped")
            }) {
                VStack(spacing: 4) {
                    Image(systemName: "questionmark.circle.fill")
                        .font(.system(size: 26, weight: .regular))
                    Text("Help")
                        .font(.caption2)
                }
                .padding(8)
            }
            
            Spacer()
        }
    }
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGray6)
                .ignoresSafeArea()
            
            if shouldShowAllButtons {
                // Show all buttons in one row for iPad landscape
                allButtons
                    .padding(.top, 10)
                    .padding(.bottom, 10)
            } else {
                // Show primary/secondary buttons with More button for smaller screens
                HStack(spacing: 0) {
                    // Dynamic content area
                    if showingMoreOptions {
                        secondaryButtons
                    } else {
                        primaryButtons
                    }
                    
                    // Fixed More button
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showingMoreOptions.toggle()
                        }
                    }) {
                        Image(systemName: showingMoreOptions ? "chevron.right" : "ellipsis")
                            .font(.system(size: 26, weight: .regular))
                            .padding(10)
                            .foregroundColor(.blue)
                    }
                    .padding(.trailing)
                }
                .padding(.top, 10)
                .padding(.bottom, 10)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            isLandscape = UIDevice.current.orientation.isLandscape
        }
    }
}

//struct MainButtonRow_Previews: PreviewProvider {
//    static var previews: some View {
//        MainButtonRow()
//            .environmentObject(SourceModel())
//            .environmentObject(NavigationStateManager())
//    }
//}
