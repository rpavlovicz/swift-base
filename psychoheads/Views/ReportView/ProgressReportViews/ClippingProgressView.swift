//
//  ClippingProgressView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 6/27/25.
//


//
//  ClippingProgressView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 7/28/24.
//

import SwiftUI
import Charts

struct ClippingProgressView: View {
    
    @EnvironmentObject var sourceModel: SourceModel
    @EnvironmentObject var navigationStateManager: NavigationStateManager
    @State private var showCurrentYearOnly: Bool = false
    
    var body: some View {
        
        VStack {
            
            Toggle(isOn: $showCurrentYearOnly) {
                Text("Show Current Year Only")
            }
            .tint(.blue)
            .padding(.bottom)
            
            let linearGradient = LinearGradient(gradient: Gradient(colors: [Color.accentColor.opacity(0.4), Color.accentColor.opacity(0)]),
                                                startPoint: .top,
                                                endPoint: .bottom)
                        
            Chart {
                ForEach(sourceModel.cumulativeClippingsData(showCurrentYearOnly: showCurrentYearOnly), id: \.date) { dataPoint in
                    if showCurrentYearOnly {
                        LineMark(
                            x: .value("Date", dataPoint.date),
                            y: .value("Cumulative Clippings", dataPoint.count)
                        )
                        .interpolationMethod(.monotone)
                        .symbol(Circle().strokeBorder())
                    } else {
                        LineMark(
                            x: .value("Date", dataPoint.date),
                            y: .value("Cumulative Clippings", dataPoint.count)
                        )
                        .interpolationMethod(.monotone)
                    }
                }
                
                ForEach(sourceModel.cumulativeClippingsData(showCurrentYearOnly: showCurrentYearOnly), id: \.date) { dataPoint in
                    AreaMark(
                        x: .value("Date", dataPoint.date),
                        y: .value("Cumulative Clippings", dataPoint.count)
                    )
                    .interpolationMethod(.monotone)
                    .foregroundStyle(linearGradient)
                }
            }
            .padding(.bottom)
            
            HStack {
                Text("Average clippings added per day: \(String(format: "%.1f", calculateAverageClippingsPerDay()))")                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            //.padding()
            
        } // VStack
        
        
    } // body
    
    private func calculateAverageClippingsPerDay() -> Double {
        let clippingsData = sourceModel.cumulativeClippingsData(showCurrentYearOnly: showCurrentYearOnly)
        guard let firstDate = clippingsData.first?.date, let lastDate = clippingsData.last?.date else {
            return 0.0
        }
        let totalDays = Calendar.current.dateComponents([.day], from: firstDate, to: lastDate).day ?? 1
        let totalClippings = clippingsData.last?.count ?? 0
        return Double(totalClippings) / Double(totalDays)
    }
}

//struct ClippingProgressView_Previews: PreviewProvider {
//    static var previews: some View {
//        ClippingProgressView()
//            .environmentObject(SourceModel())
//            .environmentObject(NavigationStateManager())
//    }
//}
