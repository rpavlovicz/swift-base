//
//  ReportSourceChartView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 6/27/25.
//


//
//  ReportSourceByYear.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 6/10/24.
//

import SwiftUI
import Charts

struct ReportSourceChartView: View {
    
    @EnvironmentObject var sourceModel: SourceModel
    @State private var isScrollable: Bool = false // State property for toggle
    @State private var sourceCoverageFilter: SourceCoverageFilter = .withClippings
    
    private let barWidth: CGFloat = 12
    private let labelXOffset: CGFloat = -20
    
    private var yearCounts: [(year: Int, count: Int)] {
        sourceModel.sourceYearCounts(for: sourceCoverageFilter)
    }
    
    private var clippedYearCounts: [(year: Int, count: Int)] {
        sourceModel.sourceYearCounts(for: .withClippings)
    }
    
    private var yearDomain: ClosedRange<Int>? {
        guard let minYear = sourceModel.minYear(for: sourceCoverageFilter),
              let maxYear = sourceModel.maxYear(for: sourceCoverageFilter),
              !yearCounts.isEmpty else {
            return nil
        }
        return minYear...maxYear
    }

    var body: some View {
        VStack(alignment: .leading) {
            
            if #available(iOS 17.0, *) {
                if let yearDomain {
                    let minYear = yearDomain.lowerBound
                    let maxYear = yearDomain.upperBound
                    // Toggle for scrollable axes
                    Toggle("Zoomed view", isOn: $isScrollable)
                        .tint(.blue)
                        .padding(.bottom)
                    
                    // Conditional chart with scrollable axes
                    if isScrollable {
                        Chart {
                            sourceBarsContent()
                        }
                        .chartScrollableAxes(.horizontal)
                        .chartXAxis {
                            AxisMarks(values: Array(minYear...maxYear)) { value in
                                AxisGridLine()
                                AxisValueLabel {
                                    if let intValue = value.as(Int.self) {
                                        Text(verbatim: "    \(intValue)")
                                            .rotationEffect(.degrees(50))
                                            .font(.caption)
                                            .offset(x: labelXOffset, y: 0)
                                    }
                                }
                            }
                        }
                        .chartXScale(domain: minYear-1...maxYear+3)
                        .frame(height: 150)
                        .padding(.bottom, 40) // Add extra padding to the bottom
                        
                    } else { // case for non-scrollable chart
                        Chart {
                            sourceBarsContent()
                        }
                        .chartXAxis {
                            AxisMarks(values: Array(stride(from: minYear, through: maxYear, by: 5))) { value in
                                AxisGridLine()
                                AxisValueLabel {
                                    if let intValue = value.as(Int.self) {
                                        Text(verbatim: "    \(intValue)")
                                            .rotationEffect(.degrees(50))
                                            .font(.caption)
                                            .offset(x: labelXOffset, y: 0)
                                    }
                                }
                            }
                        }
                        .chartXScale(domain: minYear-2...maxYear+7)
                        .frame(height: 150)
                        .padding(.bottom, 40)
                    }
                    
                    coverageMenu
                } else {
                    Text("No data available")
                        .padding()
                    coverageMenu
                }
            } else {
                // Fallback for earlier iOS versions
                Text("Charts are available only on iOS 17.0 and later")
                    .padding()
            }

        } // iOS 17.0 check
        
    } // main VStack
    
    @ChartContentBuilder
    private func sourceBarsContent() -> some ChartContent {
        if sourceCoverageFilter == .all {
            let clippedByYear = Dictionary(uniqueKeysWithValues: clippedYearCounts.map { ($0.year, $0.count) })
            ForEach(yearCounts, id: \.year) { yearCount in
                let clippedCount = clippedByYear[yearCount.year] ?? 0
                BarMark(
                    x: .value("Year", yearCount.year),
                    y: .value("Count", clippedCount),
                    width: .fixed(barWidth)
                )
                .foregroundStyle(.blue)
                
                BarMark(
                    x: .value("Year", yearCount.year),
                    yStart: .value("Cut Sources", clippedCount),
                    yEnd: .value("Total Sources", yearCount.count),
                    width: .fixed(barWidth)
                )
                .foregroundStyle(.gray.opacity(0.4))
            }
        } else {
            ForEach(yearCounts, id: \.year) { yearCount in
                BarMark(
                    x: .value("Year", yearCount.year),
                    y: .value("Count", yearCount.count),
                    width: .fixed(barWidth)
                )
            }
        }
    }
    
    private var coverageMenu: some View {
        Menu {
            ForEach(SourceCoverageFilter.allCases) { filter in
                Button {
                    sourceCoverageFilter = filter
                } label: {
                    if sourceCoverageFilter == filter {
                        Label(filter.displayName, systemImage: "checkmark")
                    } else {
                        Text(filter.displayName)
                    }
                }
            }
        } label: {
            HStack(spacing: 4) {
                Text(sourceCoverageFilter.displayName)
                    .font(.subheadline)
                Image(systemName: "chevron.down")
                    .font(.caption2)
            }
        }
    }
}

struct ReportSourceChartView_Previews: PreviewProvider {
    static var previews: some View {
        ReportSourceChartView()
            .environmentObject(SourceModel())
    }
}
