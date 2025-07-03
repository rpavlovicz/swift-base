//
//  ReportAverageClippingsChartView2.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 6/27/25.
//


//
//  ReportAverageClippingsView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 6/10/24.
//

import SwiftUI
import Charts

struct ReportAverageClippingsChartView2: View {
    
    @EnvironmentObject var sourceModel: SourceModel
    
    @State private var selectedSourceTitle: String?
    
    var selectedSourceData: (title: String, averageClippings: Double, standardDeviation: Double, totalCount: Int)? {
        guard let selectedSourceTitle = selectedSourceTitle else { return nil }
        let sources = sourceModel.sources.filter { $0.title == selectedSourceTitle }
        guard !sources.isEmpty else { return nil }
        let totalClippings = sources.reduce(0) { $0 + $1.clippings.count }
        let averageClippings = Double(totalClippings) / Double(sources.count)
        let standardDeviation = calculateStandardDeviation(for: sources)
        let totalCount = sources.count
        return (title: selectedSourceTitle, averageClippings: averageClippings, standardDeviation: standardDeviation, totalCount: totalCount)
    }
    
    var maxYValue: Double {
        let maxValue = sourceModel.averageClippingsPerSource.map { $0.averageClippings }.max() ?? 0
        return ceil(maxValue / 10) * 10
    }
    
    var body: some View {
        if #available(iOS 17.0, *) {
            Chart {
                ForEach(sourceModel.averageClippingsPerSource, id: \.title) { data in
                    BarMark(
                        x: .value("Average Clippings", data.averageClippings),
                        y: .value("Source Title", data.title),
                        width: .fixed(8)
                    )
                    .opacity(selectedSourceTitle == nil || data.title == selectedSourceTitle ? 1 : 0.5)
                    .annotation(position: .trailing) {
                        Text(String(format: "%.1f", data.averageClippings))
                            .font(.caption)
                            .foregroundColor(.black)
                    }
                    //barWidth(30)
                    
                    if let selectedSourceTitle, selectedSourceTitle == data.title {
                        RuleMark(y: .value("Selected", selectedSourceTitle))
                            .foregroundStyle(Color.gray.opacity(0.3))
                            .annotation(position: .top, alignment: .center) {
                                selectionPopover
                            }
                    }
                }
            }
            //.chartYScale(domain: 0...maxYValue) // Fix the y-axis scale
            //.chartXSelection(value: $selectedSourceTitle)            //.chartXAxisLabelPosition(.bottom)
            //.chartYAxisLabelPosition(.leading)
            .chartScrollableAxes(.vertical)
            .chartXAxis {
                AxisMarks { value in
                    AxisValueLabel {
                        if let title = value.as(String.self) {
                            Text(String(title.prefix(9)))
                                .truncationMode(.tail) // Truncate text
                                .rotationEffect(.degrees(20))
                                .offset(x: 18, y: 8)
                                .font(.caption)
                                //.frame(width: 50, alignment: .leading)
                                //.frame(height: 100)
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
    
    private func calculateStandardDeviation(for sources: [Source]) -> Double {
        let clippingsCounts = sources.map { $0.clippings.count }
        let mean = Double(clippingsCounts.reduce(0, +)) / Double(clippingsCounts.count)
        let variance = clippingsCounts.reduce(0) { $0 + pow(Double($1) - mean, 2.0) } / Double(clippingsCounts.count)
        return sqrt(variance)
    }
    
    @ViewBuilder
    var selectionPopover: some View {
        if let selectedSourceData {
            VStack(alignment: .leading) {
                Text(selectedSourceData.title)
                    .bold()
                Text("\(String(format: "%.1f", selectedSourceData.averageClippings)) ± \(String(format: "%.2f", selectedSourceData.standardDeviation)) clippings")        .font(.subheadline)
                Text("Total Sources: \(selectedSourceData.totalCount)")
                    .font(.subheadline)
            }
            .padding(6)
            .background {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.white)
                    .shadow(radius: 2)
            }
        }
    }
    
}

struct ReportAverageClippingsChartView2_Previews: PreviewProvider {
    static var previews: some View {
        ReportAverageClippingsChartView2()
            .environmentObject(SourceModel())
    }
}
