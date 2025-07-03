//
//  ReportSourceSimpleView.swift
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

struct ReportSourceSimpleView: View {
    
    @EnvironmentObject var sourceModel: SourceModel
    @EnvironmentObject var navigationStateManager: NavigationStateManager
    
    var body: some View {
        
        VStack(alignment: .leading) {            Text("Total number of sources: \(sourceModel.totalSources)")
                .padding(.bottom, 5)
            Text("Unique source titles: \(sourceModel.uniqueSourceNamesCount)")
                .font(.subheadline) // Adjusts the font size
                .foregroundColor(.secondary) // Makes the color less emphasized
        }
        .frame(maxWidth: .infinity, alignment: .leading) // Ensures left alignment
        .padding(.top, 5)
        
    } // body
}

//struct ReportSourceSimpleView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReportSourceSimpleView()
//            .environmentObject(SourceModel())
//            .environmentObject(NavigationStateManager())
//    }
//}
