//
//  ReportHeadBodyClippingsView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 6/27/25.
//


//
//  SourceReportView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 6/9/24.
//

import SwiftUI
import Charts

struct ReportHeadBodyClippingsView: View {
    
    @EnvironmentObject var sourceModel: SourceModel
    @EnvironmentObject var navigationStateManager: NavigationStateManager
    
    var headBodyData: [(category: String, count: Int)] {
        let totalHeads = sourceModel.totalHeadNotBodyClippings
        let totalBodies = sourceModel.totalBodyClippings
        return [
            (category: "Heads", count: totalHeads),
            (category: "Bodies", count: totalBodies)
        ]
    }
    
    var body: some View {
        
        Chart {
            ForEach(headBodyData, id: \.category) { data in
                BarMark(
                    x: .value("Category", data.category),
                    y: .value("Count", data.count)
                )
                .foregroundStyle(data.category == "Heads" ? .blue : .green)
                .annotation(position: .overlay) {
                    Text("\(data.count)")
                        .bold()
                        .foregroundColor(.white)
                }
            }
        }
        .chartYAxisLabel("Number of Clippings")
        .chartLegend(.hidden)
        .frame(height: 200)
        
    } // body
}

struct ReportHeadBodyClippingsView_Previews: PreviewProvider {
    static var previews: some View {
        ReportHeadBodyClippingsView()
            .environmentObject(SourceModel())
            .environmentObject(NavigationStateManager())
    }
}
