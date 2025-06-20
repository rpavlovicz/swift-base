//
//  ViewThree.swift
//  BaseProject
//
//  Created by Template on 2024.
//

import SwiftUI

struct ViewThree: View {
    @EnvironmentObject var sourceModel: SourceModel
    @EnvironmentObject var navigationStateManager: NavigationStateManager
    @State private var selectedTimeRange: TimeRange = .allTime
    
    enum TimeRange: String, CaseIterable {
        case allTime = "All Time"
        case thisWeek = "This Week"
        case thisMonth = "This Month"
        case thisYear = "This Year"
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header Stats
                StatsHeaderView()
                
                // Time Range Picker
                Picker("Time Range", selection: $selectedTimeRange) {
                    ForEach(TimeRange.allCases, id: \.self) { range in
                        Text(range.rawValue).tag(range)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                // Color Distribution Chart
                ColorDistributionView()
                
                // Shape Type Distribution
                ShapeTypeDistributionView()
                
                // Recent Activity
                RecentActivityView()
                
                // Quick Actions
                QuickActionsView()
            }
            .padding()
        }
        .navigationTitle("View Three")
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Stats Header View
struct StatsHeaderView: View {
    @EnvironmentObject var sourceModel: SourceModel
    
    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 16) {
            StatCard(
                title: "Total Shapes",
                value: "\(sourceModel.shapes.count)",
                icon: "square.stack.3d.up",
                color: .blue
            )
            
            StatCard(
                title: "Colors",
                value: "\(Set(sourceModel.shapes.map { $0.color }).count)",
                icon: "paintpalette",
                color: .green
            )
            
            StatCard(
                title: "Types",
                value: "\(Set(sourceModel.shapes.map { $0.imageName }).count)",
                icon: "gearshape",
                color: .orange
            )
        }
    }
}

// MARK: - Stat Card
struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// MARK: - Color Distribution View
struct ColorDistributionView: View {
    @EnvironmentObject var sourceModel: SourceModel
    
    private var colorCounts: [(Color, Int)] {
        let colors = [Color.red, .green, .blue, .yellow, .purple]
        return colors.map { color in
            (color, sourceModel.shapes.filter { $0.color == color }.count)
        }.filter { $0.1 > 0 }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Color Distribution")
                .font(.headline)
            
            if colorCounts.isEmpty {
                Text("No shapes to display")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                VStack(spacing: 12) {
                    ForEach(colorCounts, id: \.0) { color, count in
                        HStack {
                            Circle()
                                .fill(color)
                                .frame(width: 20, height: 20)
                            
                            Text(colorName(for: color))
                                .font(.subheadline)
                            
                            Spacer()
                            
                            Text("\(count)")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            
                            // Progress bar
                            ProgressView(value: Double(count), total: Double(sourceModel.shapes.count))
                                .frame(width: 60)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private func colorName(for color: Color) -> String {
        switch color {
        case .red: return "Red"
        case .green: return "Green"
        case .blue: return "Blue"
        case .yellow: return "Yellow"
        default: return "Unknown"
        }
    }
}

// MARK: - Shape Type Distribution View
struct ShapeTypeDistributionView: View {
    @EnvironmentObject var sourceModel: SourceModel
    
    private var typeCounts: [(String, Int)] {
        let types = ["circle", "rectangle", "square", "triangle", "star", "arrow", "heart", "oval"]
        return types.map { type in
            (type, sourceModel.shapes.filter { $0.type == type }.count)
        }.filter { $0.1 > 0 }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Shape Types")
                .font(.headline)
            
            if typeCounts.isEmpty {
                Text("No shapes to display")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 12) {
                    ForEach(typeCounts, id: \.0) { type, count in
                        HStack {
                            // Use the first available image for this type
                            let sampleImage = sourceModel.shapes.first { $0.type == type }?.imageName ?? type
                            Image(sampleImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                                .foregroundColor(.gray)
                            
                            VStack(alignment: .leading) {
                                Text(type.capitalized)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                
                                Text("\(count) shapes")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(8)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// MARK: - Recent Activity View
struct RecentActivityView: View {
    @EnvironmentObject var sourceModel: SourceModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Activity")
                .font(.headline)
            
            VStack(spacing: 12) {
                ForEach(Array(sourceModel.shapes.prefix(3).enumerated()), id: \.element.id) { index, shape in
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.green)
                        
                        VStack(alignment: .leading) {
                            Text("Added \(shape.name)")
                                .font(.subheadline)
                            
                            Text("Just now")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(shape.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .foregroundColor(shape.color)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// MARK: - Quick Actions View
struct QuickActionsView: View {
    @EnvironmentObject var sourceModel: SourceModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Actions")
                .font(.headline)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                QuickActionButton(
                    title: "Add Shape",
                    icon: "plus.circle.fill",
                    color: .blue
                ) {
                    sourceModel.addSampleShape()
                }
                
                QuickActionButton(
                    title: "Reset Data",
                    icon: "arrow.clockwise.circle.fill",
                    color: .orange
                ) {
                    sourceModel.resetToSampleData()
                }
                
                QuickActionButton(
                    title: "Export Data",
                    icon: "square.and.arrow.up.circle.fill",
                    color: .green
                ) {
                    // Template: Add export functionality
                    print("Export data tapped")
                }
                
                QuickActionButton(
                    title: "Settings",
                    icon: "gear.circle.fill",
                    color: .gray
                ) {
                    // Template: Navigate to settings
                    print("Settings tapped")
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// MARK: - Quick Action Button
struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview
struct ViewThree_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ViewThree()
                .environmentObject(SourceModel())
                .environmentObject(NavigationStateManager())
        }
    }
}

