//
//  ReportView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 6/27/25.
//


//
//  ReportView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 7/20/23.
//

import SwiftUI
import Charts

struct ReportView: View {
    
    @EnvironmentObject var sourceModel: SourceModel
    @EnvironmentObject var navigationStateManager: NavigationStateManager
    @State private var cacheUsage: String = ""
    
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
        
        List {
            
            Section(header: Text("Sources")) {
                
                NavigationLink(value: SelectionState.reportSourceDetailView, label: {
                    ReportSourceSimpleView()
                })
                
            }
            
            Section(header: Text("Clippings")) {
                
                NavigationLink(value: SelectionState.reportClippingDetailView, label: {
                    ReportClippingSimpleView(showBarCharts: true)
                })
                
            }
            
            Section(header: Text("Progress")) {
                
                NavigationLink(value: SelectionState.progressReportView, label: {
                    ProgressReportSimpleView()
                })
                
            }
                                    
            Section (header: Text("Usage")) {
                
                Text("Cache Usage: \(cacheUsage)")
                    .onAppear {
                        cacheUsage = CacheManager.shared.totalCacheUsage()
                    }
                        
            } // Usage section
            
        } // List
        
    } // body
        
            
//            Text("Number of unique names: \(sourceModel.uniqueHeadNamesCount)")
//                .padding(.bottom, 5)
//            
//            Text("Woman Heads: \(sourceModel.totalWomanHeadNotBodyClippings)")
//            Text("Unique woman names: \(sourceModel.uniqueWomanHeadNamesCount)")
//                .padding(.bottom, 5)
//            Text("Man Heads: \(sourceModel.totalMaleHeadNotBodyClippings)")
//            Text("Unique man names: \(sourceModel.uniqueManHeadNamesCount)")
//            
//            
//            Text("Cache Usage: \(cacheUsage)")
//                .padding(.top, 35)
//                .padding(.bottom, 5)
//                .onAppear {
//                    cacheUsage = CacheManager.shared.totalCacheUsage()
//                }
        
        
}

struct ClippingData: Identifiable {
    var id = UUID()
    var category: String
    var value: Double
}

//struct ReportView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReportView()
//            .environmentObject(SourceModel())
//            .environmentObject(NavigationStateManager())
//    }
//}
