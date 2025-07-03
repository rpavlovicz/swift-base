//
//  ReportTopSourcesView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 6/27/25.
//


//
//  ReportTopSourcesView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 6/10/24.
//


import SwiftUI
import Charts

struct ReportTopSourcesView: View {
    
    @EnvironmentObject var sourceModel: SourceModel
    @EnvironmentObject var navigationStateManager: NavigationStateManager
    @State private var isSortedDescending = true
    
    var sortedSourceCounts: [(name: String, count: Int)] {
        let sourceCounts = sourceModel.sourceCounts
        return isSortedDescending ? sourceCounts : sourceCounts.reversed()
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Toggle("Sort Descending", isOn: $isSortedDescending)
                .tint(.blue)
                .padding(.bottom)
            
            List(sortedSourceCounts, id: \.name) { source in
                HStack {
                    Text(source.name)
                    Spacer()
                    Text("\(source.count)")
                }
            }
            .listStyle(PlainListStyle())
        }
        
    } // body
}

struct ReportTopSourcesView_Previews: PreviewProvider {
    static var previews: some View {
        ReportTopSourcesView()
            .environmentObject(SourceModel())
            .environmentObject(NavigationStateManager())
    }
}
