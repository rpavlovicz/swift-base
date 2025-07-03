//
//  ViewThree.swift
//  psychoheads
//
//  Created by Template on 2024.
//

import SwiftUI

struct ViewThree: View {
    @EnvironmentObject var sourceModel: SourceModel
    @EnvironmentObject var navigationStateManager: NavigationStateManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Text("Analytics Dashboard")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Source and Clipping Statistics")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top)
                
                // Key Metrics
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    MetricCard(
                        title: "Total Sources",
                        value: "\(sourceModel.totalSources)",
                        icon: "doc.text",
                        color: .blue
                    )
                    
                    MetricCard(
                        title: "Total Clippings",
                        value: "\(sourceModel.totalClippings)",
                        icon: "photo",
                        color: .green
                    )
                    
                    MetricCard(
                        title: "Head Clippings",
                        value: "\(sourceModel.totalHeadNotBodyClippings)",
                        icon: "person.crop.circle",
                        color: .orange
                    )
                    
                    MetricCard(
                        title: "Body Clippings",
                        value: "\(sourceModel.totalBodyClippings)",
                        icon: "person.fill",
                        color: .purple
                    )
                }
                .padding(.horizontal)
                
                // Source Types Chart
                VStack(alignment: .leading, spacing: 16) {
                    Text("Sources by Type")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    SourceTypeChart()
                }
                
                // Year Distribution
                VStack(alignment: .leading, spacing: 16) {
                    Text("Sources by Year")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    YearDistributionChart()
                }
                
                // Action Buttons
                VStack(spacing: 12) {
                    Button("Refresh Data") {
                        sourceModel.getSources()
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("Generate Report") {
                        // TODO: Implement report generation
                        print("Generate report button tapped")
                    }
                    .buttonStyle(.bordered)
                }
                .padding(.bottom)
            }
        }
        .navigationTitle("View Three")
    }
}

// MARK: - Metric Card
struct MetricCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(color)
            
            Text(value)
                .font(.title)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// MARK: - Source Type Chart
struct SourceTypeChart: View {
    @EnvironmentObject var sourceModel: SourceModel
    
    private var typeData: [(String, Int)] {
        let types = ["magazine", "newspaper", "book"]
        return types.map { type in
            (type, sourceModel.sources.filter { $0.type == type }.count)
        }.filter { $0.1 > 0 }
    }
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(typeData, id: \.0) { type, count in
                HStack {
                    Text(type.capitalized)
                        .font(.subheadline)
                        .frame(width: 80, alignment: .leading)
                    
                    ProgressView(value: Double(count), total: Double(sourceModel.totalSources))
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                    
                    Text("\(count)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(width: 30, alignment: .trailing)
                }
            }
            
            if typeData.isEmpty {
                Text("No source type data available")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding()
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - Year Distribution Chart
struct YearDistributionChart: View {
    @EnvironmentObject var sourceModel: SourceModel
    
    private var yearData: [(Int, Int)] {
        sourceModel.sourceYearCounts
    }
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(yearData.prefix(5), id: \.0) { year, count in
                HStack {
                    Text("\(year)")
                        .font(.subheadline)
                        .frame(width: 50, alignment: .leading)
                    
                    ProgressView(value: Double(count), total: Double(yearData.map { $0.1 }.max() ?? 1))
                        .progressViewStyle(LinearProgressViewStyle(tint: .green))
                    
                    Text("\(count)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(width: 30, alignment: .trailing)
                }
            }
            
            if yearData.isEmpty {
                Text("No year data available")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding()
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - Preview
struct ViewThree_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ViewThree()
                .environmentObject(SourceModel())
                .environmentObject(NavigationStateManager())
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        }
    }
}

