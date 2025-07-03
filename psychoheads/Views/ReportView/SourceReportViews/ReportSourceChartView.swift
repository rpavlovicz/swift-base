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

    var body: some View {
        VStack(alignment: .leading) {
            
            if #available(iOS 17.0, *) {
                // Histogram Chart for source years
                if let minYear = sourceModel.minYear, let maxYear = sourceModel.maxYear {
                    
                    let labelXOffset: CGFloat = -20
                    
                    // Toggle for scrollable axes
                    Toggle("Zoomed view", isOn: $isScrollable)
                        .tint(.blue)
                        .padding(.bottom)
                    
                    // Conditional chart with scrollable axes
                    if isScrollable {
                        Chart {
                            ForEach(sourceModel.sourceYearCounts, id: \.year) { yearCount in
                                BarMark(
                                    x: .value("Year", yearCount.year),
                                    y: .value("Count", yearCount.count),
                                    width: .fixed(20) // Adjust the bar width
                                )
                            }
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
                                            .offset(x: labelXOffset, y: 0) // Move label to the left
                                    }
                                }
                            }
                        }
                        .chartXScale(domain: minYear-1...maxYear+3)
                        .frame(height: 150)
                        .padding(.bottom, 40) // Add extra padding to the bottom
                        
                    } else { // case for non-scrollable chart
                        Chart {
                            ForEach(sourceModel.sourceYearCounts, id: \.year) { yearCount in
                                BarMark(
                                    x: .value("Year", yearCount.year),
                                    y: .value("Count", yearCount.count)
                                )
                            }
                        }
                        .chartXAxis {
                            AxisMarks(values: Array(stride(from: minYear, through: maxYear, by: 5))) { value in
                                AxisGridLine()
                                AxisValueLabel {
                                    if let intValue = value.as(Int.self) {
                                        Text(verbatim: "    \(intValue)")
                                            .rotationEffect(.degrees(50))
                                            .font(.caption)
                                            .offset(x: labelXOffset, y: 0) // Move label to the left
                                    }
                                }
                            }
                        }
                        .chartXScale(domain: minYear-2...maxYear+7)
                        .frame(height: 150)
                        .padding(.bottom, 40) // Add extra padding to the bottom
                    }
                } else {
                    Text("No data available")
                        .padding()
                }
            } else {
                // Fallback for earlier iOS versions
                Text("Charts are available only on iOS 17.0 and later")
                    .padding()
            }

        } // iOS 17.0 check
        
    } // main VStack
}

struct ReportSourceChartView_Previews: PreviewProvider {
    static var previews: some View {
        ReportSourceChartView()
            .environmentObject(SourceModel())
    }
}
