//
//  SourceProgressView.swift
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

struct SourceProgressView: View {
    
    @EnvironmentObject var sourceModel: SourceModel
    @EnvironmentObject var navigationStateManager: NavigationStateManager
    @State private var showCurrentYearOnly: Bool = false
    @State private var selectedDataPoint: Date? = nil
    
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
            
            if #available(iOS 17.0, *) {
                Chart {
                    ForEach(sourceModel.cumulativeSourcesData(showCurrentYearOnly: showCurrentYearOnly), id: \.date) { dataPoint in
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
                    
                    ForEach(sourceModel.cumulativeSourcesData(showCurrentYearOnly: showCurrentYearOnly), id: \.date) { dataPoint in
                        AreaMark(
                            x: .value("Date", dataPoint.date),
                            y: .value("Cumulative Clippings", dataPoint.count)
                        )
                        .interpolationMethod(.monotone)
                        .foregroundStyle(linearGradient)
                    }
                    
                }
                .chartXSelection(value: $selectedDataPoint)
                .padding(.bottom)
            } else {
                // Fallback on earlier versions
            }
            
        } // VStack
        
        
    } // body
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
}

//struct SourceProgressView_Previews: PreviewProvider {
//    static var previews: some View {
//        SourceProgressView()
//            .environmentObject(SourceModel())
//            .environmentObject(NavigationStateManager())
//    }
//}
