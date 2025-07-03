//
//  ProgressReportView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 6/27/25.
//


//
//  SourceReportView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 7/6/24.
//

import SwiftUI
import Charts

struct ProgressReportView: View {
    
    @EnvironmentObject var sourceModel: SourceModel
    @EnvironmentObject var navigationStateManager: NavigationStateManager
    
    
    
    var body: some View {
        
        List {
        
            Section(header: Text("Cumulative Sources Added")) {
                SourceProgressView()
                    .frame(height: 250)
            }
            
            Section(header: Text("Cumulative Clippings Added")) {
                ClippingProgressView()
                    .frame(height: 300)
            }
                                    
        }
        
        
    } // body
}

//struct ProgressReportView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProgressReportView()
//            .environmentObject(SourceModel())
//            .environmentObject(NavigationStateManager())
//    }
//}
