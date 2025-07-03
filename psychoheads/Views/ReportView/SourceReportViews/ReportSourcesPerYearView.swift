//
//  ReportSourcesPerYearView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 6/27/25.
//


//
//  ReportSourcesPerYearView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 6/15/24.
//

import SwiftUI
import Charts

struct ReportSourcesPerYearView: View {
    @EnvironmentObject var sourceModel: SourceModel

    var body: some View {
        if #available(iOS 17.0, *) {
            
            let sourcesPerYear = sourceModel.sourcesPerYear
            let minYear = sourcesPerYear.first?.year ?? 0
            let maxYear = sourcesPerYear.last?.year ?? 0
            
            Chart {
                ForEach(sourceModel.sourcesPerYear, id: \.year) { data in
                    BarMark(
                        x: .value("Year", data.year),
                        y: .value("Sources", data.count),
                        width: .fixed(50) // Adjust the bar width
                    )
                }
            }
            .chartYAxisLabel("Number of Sources")
            .chartXAxisLabel("Year")
            .chartXScale(domain: minYear-1...maxYear+1) // Set the x-axis range
            .chartXAxis {
                AxisMarks(values: Array(minYear...maxYear)) { value in
                    AxisGridLine()
                    AxisValueLabel {
                        if let intValue = value.as(Int.self) {
                            Text(verbatim: "    \(intValue)")
                                //.rotationEffect(.degrees(50))
                                .font(.caption)
                                .offset(x: -35, y: 0) // Move label to the left
                        }
                    }
                }
            }
            .frame(height: 200)
            .padding()
        } else {
            Text("Charts are available only on iOS 17.0 and later")
                .padding()
        }
    }
}

struct ReportSourcesPerYearView_Previews: PreviewProvider {
    static var previews: some View {
        ReportSourcesPerYearView()
            .environmentObject(SourceModel())
    }
}

