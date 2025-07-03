//
//  ReportClippingSimpleView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 6/27/25.
//


//
//  ReportClippingSimpleView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 7/6/24.
//

import SwiftUI
import Charts

struct ReportClippingSimpleView: View {
    
    @EnvironmentObject var sourceModel: SourceModel
    @EnvironmentObject var navigationStateManager: NavigationStateManager
    
    var showBarCharts: Bool
    
    var clippingData: [ClippingData2] {
        var result = [ClippingData2]()
        var initialValue: Double = 0
        
        let categories = [
            ("Bodies", Double(sourceModel.totalBodyClippings)),
            ("Heads", Double(sourceModel.totalHeadNotBodyClippings))
        ]
        
        for category in categories {
            let endValue = initialValue + category.1
            result.append(ClippingData2(category: category.0, value: category.1, startValue: initialValue, endValue: endValue))
            initialValue = endValue
        }
        
        return result
    }
    
    var headClippingData: [ClippingData2] {
        var result = [ClippingData2]()
        var initialValue: Double = 0
        
        let categories = [
            ("Male", Double(sourceModel.totalMaleHeadNotBodyClippings)),
            ("Female", Double(sourceModel.totalWomanHeadNotBodyClippings)),
            ("Trans", Double(sourceModel.totalTransHeadNotBodyClippings)),
            ("Animal", Double(sourceModel.totalAnimalHeadNotBodyClippings))
        ]
        
        for category in categories {
            let endValue = initialValue + category.1
            result.append(ClippingData2(category: category.0, value: category.1, startValue: initialValue, endValue: endValue))
            initialValue = endValue
        }
        
        return result
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            Text("Total number of clippings: \(sourceModel.totalClippings)")
            
            
            //MARK: single stacked bar chart for total clippings
            if showBarCharts {
                Chart(clippingData) { data in
                    BarMark(
                        xStart: .value("Start", data.startValue),
                        xEnd: .value("End", data.endValue),
                        y: .value("Category", 0),
                        height: 50
                    )
                    .foregroundStyle(by: .value("Category", data.category))
                    .annotation(position: .overlay) {
                        VStack {
                            Text(data.category)
                                .foregroundStyle(Color.white)
                                .bold()
                            Text("\(Int(data.value))")
                                .foregroundStyle(Color.white)
                                .bold()
                        }
                    }
                }
                .chartXAxis(.hidden)
                .chartYAxis(.hidden)
                .chartLegend(.hidden)
                .fixedSize(horizontal: false, vertical: true)
                
                //MARK: single stacked bar chart for head clippings
                
                Text("Head clippings:")
                Chart(headClippingData) { data in
                    BarMark(
                        xStart: .value("Start", data.startValue),
                        xEnd: .value("End", data.endValue),
                        y: .value("Category", 0),
                        height: 50
                    )
                    .foregroundStyle(by: .value("Category", data.category))
                    .annotation(position: .overlay) {
                        VStack {
                            Text(data.category)
                                .foregroundStyle(Color.white)
                                .bold()
                            Text("\(Int(data.value))")
                                .foregroundStyle(Color.white)
                                .bold()
                        }
                    }
                }
                .chartXAxis(.hidden)
                .chartYAxis(.hidden)
                .chartLegend(.hidden)
                .fixedSize(horizontal: false, vertical: true)
            }
            
            
        }
        .frame(maxWidth: .infinity, alignment: .leading) // Ensures left alignment
        .padding(.top, 5)
        
    }
}

struct ClippingData2: Identifiable {
    let id = UUID()
    let category: String
    let value: Double
    let startValue: Double
    let endValue: Double
}

//struct ReportClippingSimpleView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReportClippingSimpleView(showBarCharts: true)
//            .environmentObject(SourceModel())
//            .environmentObject(NavigationStateManager())
//    }
//}
