//
//  ReportHeadClippingsDetailView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 6/27/25.
//


//
//  ReportHeadClippingsDetailView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 7/6/24.
//

import SwiftUI
import Charts

struct ReportHeadClippingsDetailView: View {
    
    @EnvironmentObject var sourceModel: SourceModel
    @EnvironmentObject var navigationStateManager: NavigationStateManager
    
    var headDetailData: [(category: String, count: Int)] {
        let totalMaleHeads = sourceModel.totalMaleHeadNotBodyClippings
        let totalFemaleHeads = sourceModel.totalWomanHeadNotBodyClippings
        let totalTransHeads = sourceModel.totalTransHeadNotBodyClippings
        let totalAnimalHeads = sourceModel.totalAnimalHeadNotBodyClippings
        let data = [
            (category: "Male", count: totalMaleHeads),
            (category: "Female", count: totalFemaleHeads),
            (category: "Trans", count: totalTransHeads),
            (category: "Animal", count: totalAnimalHeads)
        ]
        return data.sorted { $0.count > $1.count }
    }
    
    var body: some View {
        
        let maxCount = headDetailData.map { $0.count }.max() ?? 0
        let threshold = Double(maxCount) / 3.0
        
        Chart {
            ForEach(headDetailData, id: \.category) { data in
                BarMark(
                    x: .value("Count", data.count),
                    y: .value("Category", data.category)
                )
                .foregroundStyle(by: .value("Category", data.category))
                .annotation(position: data.count >= Int(threshold) ? .overlay : .trailing) {
                    Text("\(data.count)")
                        .bold()
                        .foregroundColor(data.count >= Int(threshold) ? .white : .black)
                        .padding(5)
                        .cornerRadius(5)
                }
//                .annotation(position: .overlay) {
//                    Text("\(data.count)")
//                        .bold()
//                        .foregroundColor(.white)
//                }
//                .annotation(position: .trailing, alignment: .leading, content: {
//                    Text(String(data.count))
//                })
            }
        }
        .chartYAxisLabel("Number of Clippings")
        .chartLegend(.hidden)
        .frame(height: 300)
        
    }
    
}

struct ReportHeadClippingsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ReportHeadClippingsDetailView()
            .environmentObject(SourceModel())
            .environmentObject(NavigationStateManager())
    }
}
