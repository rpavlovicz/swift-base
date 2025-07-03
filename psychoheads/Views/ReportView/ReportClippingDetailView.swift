//
//  ReportClippingDetailView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 6/27/25.
//


//
//  SourceDetailReportView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 7/6/24.
//

import SwiftUI
import Charts

struct ReportClippingDetailView: View {
    
    @EnvironmentObject var sourceModel: SourceModel
    @EnvironmentObject var navigationStateManager: NavigationStateManager
    
//    @State private var minYear: Int?
//    @State private var maxYear: Int?
//    @State private var isScrollable: Bool = false // State property for toggle
    
    var body: some View {
        
        List {
            
            Section {
                
                ReportClippingSimpleView(showBarCharts: false)
                    .padding(.bottom, 5)
                
            }
            
            Section(header: Text("clipping type")) {
                
                ReportHeadBodyClippingsView()
                
            }
            
            Section(header: Text("head type")) {
                
                ReportHeadClippingsDetailView()
                
            }
            
            Section(header: Text("Female Head Names")) {
                
                ReportTopFemaleHeadsView()
                    .frame(height: 250)
            }
            
            Section(header: Text("Male Head Names")) {
                
                ReportTopMaleHeadsView()
                    .frame(height: 250)
            }

            
//            Section(header: Text("Head clipping details")) {
//                
//                ClippingPieChartView1()
//                
//            }
            
//            Section(header: Text("Head clippgin details 2")) {
//                
//                ClippingPieChartView2()
//                
//            }
            
            Section(header: Text("number of clippings added per year")) {
                
                ReportClippingsPerYearView()
                
            }
            
        } // list
        
    } // body
}

//extension View {
//    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
//        if condition {
//            transform(self)
//        } else {
//            self
//        }
//    }
//}

//struct ReportClippingDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReportClippingDetailView()
//            .environmentObject(SourceModel())
//            .environmentObject(NavigationStateManager())
//    }
//}
