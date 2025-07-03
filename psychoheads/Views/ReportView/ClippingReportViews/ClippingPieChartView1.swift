//
//  ClippingPieChartView1.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 6/27/25.
//


//
//  ClippingPieChart1.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 7/6/24.
//

import SwiftUI
import Charts

struct ClippingPieChartView1: View {
    
    @EnvironmentObject var sourceModel: SourceModel
    @EnvironmentObject var navigationStateManager: NavigationStateManager
    
    var clippingData: [ClippingData] {
        [
            ClippingData(category: "Bodies", value: Double(sourceModel.totalBodyClippings)),
            ClippingData(category: "Heads", value: Double(sourceModel.totalHeadNotBodyClippings))
        ]
    }
    
    var headClippingData: [ClippingData] {
        [
            ClippingData(category: "Man", value: Double(sourceModel.totalMaleHeadNotBodyClippings)),
            ClippingData(category: "Woman", value: Double(sourceModel.totalWomanHeadNotBodyClippings)),
            ClippingData(category: "Trans", value: Double(sourceModel.totalTransHeadNotBodyClippings)),
            ClippingData(category: "Animal", value: Double(sourceModel.totalAnimalHeadNotBodyClippings))
        ]
    }
    
    var body: some View {
       
        HStack {
            if #available(iOS 17.0, *) {
                // Donut Chart
                ZStack {
                    Chart(clippingData) { data in
                        SectorMark(
                            angle: .value("Value", data.value),
                            innerRadius: .ratio(0.6),
                            outerRadius: .ratio(1.0),
                            angularInset: 1.5
                        )
                        .foregroundStyle(by: .value("Category", data.category))
                        .cornerRadius(5)
                    }
                    .frame(height: 150)
                    .padding()
                    VStack(alignment: .center) {
                        Text("Number of")
                            .frame(height: 10)
                        Text("clippings:")
                        
                    }
                    //.frame(maxWidth: .infinity, maxHeight: 100, alignment: .center)
                }
                
            } else {
                // Fallback for earlier iOS versions
                Text("Donut chart is available only on iOS 17.0 and later")
                    .padding()
                Text("Body Clippings: \(sourceModel.totalBodyClippings)")
                    .padding(.bottom, 5)
                Text("Head Clippings: \(sourceModel.totalHeadNotBodyClippings)")
                    .padding(.bottom, 5)
            } // clipping pie chart
            
            if #available(iOS 17.0, *) {
                // Donut Chart
                ZStack {
                    Chart(headClippingData) { data in
                        SectorMark(
                            angle: .value("Value", data.value),
                            innerRadius: .ratio(0.6),
                            outerRadius: .ratio(1.0),
                            angularInset: 1.5
                        )
                        
                        .foregroundStyle(data.category == "Man" ? .blue : data.category == "Woman" ? .pink : .gray)
                        .foregroundStyle(by: .value("Category", data.category))
                        .cornerRadius(5)
                    }
                    .frame(height: 150)
                    .padding()
                    VStack(alignment: .center) {
                        Text("Number of")
                            .frame(height: 10) // <-- Add this line for center perfectly
                        Text("heads:")
                        //                            .frame(height: 0) // <-- Add this line for center perfectly
                        
                    }
                    //.frame(maxWidth: .infinity, maxHeight: 100, alignment: .center)
                }
                
            } else {
                // Fallback for earlier iOS versions
                Text("Donut chart is available only on iOS 17.0 and later")
                    .padding()
                Text("Body Clippings: \(sourceModel.totalBodyClippings)")
                    .padding(.bottom, 5)
                Text("Head Clippings: \(sourceModel.totalHeadNotBodyClippings)")
                    .padding(.bottom, 5)
            }
            
        } // HStack
        
    }
}

struct ClippingPieChartView1_Previews: PreviewProvider {
    static var previews: some View {
        ClippingPieChartView1()
            .environmentObject(SourceModel())
            .environmentObject(NavigationStateManager())
    }
}
