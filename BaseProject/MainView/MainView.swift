//
//  MainView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 3/10/23.
//

import SwiftUI

struct MainView: View {
    
    @StateObject var sourceModel = SourceModel()
    @StateObject var navigationStateManager = NavigationStateManager()
    
    var body: some View {
        
        NavigationStack(path: $navigationStateManager.selectionPath) {
    
            VStack {
        
                Spacer()
                
                //ClownRow()
                //    .environmentObject(sourceModel)
                //    .environmentObject(navigationStateManager)
                
                Spacer()
                
                MainButtonRow()
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: 40)
                    .environmentObject(sourceModel)
                    .environmentObject(navigationStateManager)
 
            }
            .onAppear() {
                // ensure reload only happens after logout
                if sourceModel.sources.isEmpty {
                    sourceModel.reloadSources()
                }
            }
            .navigationDestination(for: SelectionState.self) { state in
                switch state {
//                    case .imageCapture:
//                        ImageCaptureView()
//                            .environmentObject(sourceModel)
//                            .environmentObject(navigationStateManager)
//                    case .library:
//                        LibraryView(sourceModel: sourceModel)
//                            .environmentObject(navigationStateManager)
//                    case .edit(let source):
//                        EditSourceView(source: source)
//                            .environmentObject(sourceModel)
//                            .environmentObject(navigationStateManager)
//                    case .sourceView(let source):
//                        LibrarySourceView(source: source)
//                        //.environmentObject(sourceModel)
//                    case .clippingView(let clipping):
//                        ClippingView(clipping: clipping)
//                            .environmentObject(sourceModel)
//                            .environmentObject(navigationStateManager)
//                   case .clippingsSwipeView(let clippings, let currentIndex):
//                        ClippingsSwipeView(clippings: clippings, currentIndex: currentIndex)
//                            .environmentObject(sourceModel)
//                            .environmentObject(navigationStateManager)
//                    case .searchClippings(let clippings):
//                        SearchClippingView(clippings: clippings)
//                            .environmentObject(sourceModel)
//                            .environmentObject(navigationStateManager)
//                    case .editClippingView(let clipping):
//                        EditClippingView(clipping: clipping)
//                            .environmentObject(sourceModel)
//                            .environmentObject(navigationStateManager)
//                    case .editClippingSourceView(let clipping):
//                        EditClippingSourceView(clipping: clipping)
//                            .environmentObject(sourceModel)
//                            .environmentObject(navigationStateManager)
//                    case .collageView:
//                        CollageView()
//                            .environmentObject(sourceModel)
//                            .environmentObject(navigationStateManager)
//                    case .reportView:
//                        ReportView()
//                            .environmentObject(sourceModel)
//                            .environmentObject(navigationStateManager)
//                    case .reportSourceDetailView:
//                        ReportSourceDetailView()
//                            .environmentObject(sourceModel)
//                            .environmentObject(navigationStateManager)
//                    case .reportClippingDetailView:
//                        ReportClippingDetailView()
//                            .environmentObject(sourceModel)
//                            .environmentObject(navigationStateManager)
//                    case .progressReportView:
//                        ProgressReportView()
//                            .environmentObject(sourceModel)
//                            .environmentObject(navigationStateManager)
//                    case .psychoView:
//                        PsychoView()
//                            .environmentObject(sourceModel)
//                            .environmentObject(navigationStateManager)
                    case .accountSettings:
                        AccountSettingsView()
                            .environmentObject(sourceModel)
                            .environmentObject(navigationStateManager)
                    case .newUser:
                        NewUserView()
                            .environmentObject(navigationStateManager)
                    case .existingUser:
                        ExistingUserView()
                            .environmentObject(navigationStateManager)
                }
            }
             
        } // NavigationStack
        
        
    }
}

//struct MainView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainView()
//    }
//}
