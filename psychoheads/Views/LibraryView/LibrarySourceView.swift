//
//  LibrarySourceView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 6/26/25.
//


//
//  LibrarySourceView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 6/12/23.
//

import SwiftUI
import Combine
import FirebaseStorage

struct LibrarySourceView: View {
    
    @ObservedObject var source: Source
    let placeholderImage: UIImage? = UIImage(named: "clipping_thumb")
    
    // Add state for sheet presentation
    @State private var showSwipeSheet: Bool = false
    @State private var swipeStartIndex: Int = 0
    
    @EnvironmentObject var sourceModel: SourceModel
    @EnvironmentObject var navigationStateManager: NavigationStateManager
    @Environment(\.managedObjectContext) private var managedObjectContext
    
    var sortedClippings: [Clipping] {
        return source.clippings.sorted { (clipping1, clipping2) -> Bool in
            switch (clipping1.isHead, clipping1.isBody, clipping2.isHead, clipping2.isBody) {
            case (true, _, false, _):
                return true
            case (false, _, true, _):
                return false
            case (true, false, true, true):
                return true
            case (true, true, true, false):
                return false
            default:
                return clipping1.size > clipping2.size
            }
        }
    }
    
    var body: some View {
        VStack {
            
//            ScrollView {
//                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
//                    ForEach(sortedClippings, id: \.id) { clipping in
//                        
//                        NavigationLink(value: SelectionState.clippingView(clipping), label: {
//                            AsyncImage1(clipping: clipping, placeholder: placeholderImage ?? UIImage())
//                        })
//                        
//                    }
//                }
//            }
//            .padding(.horizontal)// ScrollView
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                    ForEach(sortedClippings.indices, id: \.self) { index in
                        let clipping = sortedClippings[index]
                        // Replace NavigationLink with Button to trigger sheet
                        Button(action: {
                            swipeStartIndex = index
                            showSwipeSheet = true
                        }) {
                            AsyncImage1(clipping: clipping, placeholder: placeholderImage ?? UIImage())
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                
            }
            
            Text("total number of clippings = \(source.clippings.count)")
                .font(.subheadline)
            
        } // Main VStack
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(source.title)
                        .font(.headline)
                    Text(source.dateString)
                        .font(.subheadline)
                }
            }
        }
        // Sheet presentation for ClippingsSwipeView
        .sheet(isPresented: $showSwipeSheet) {
            NavigationStack {
                ClippingsSwipeView(clippings: sortedClippings, currentIndex: $swipeStartIndex)
                    .environmentObject(sourceModel)
                    .environmentObject(navigationStateManager)
                    .environment(\.managedObjectContext, managedObjectContext)
                    .navigationDestination(for: SelectionState.self) { state in
                        switch state {
                        case .sourceView(let source):
                            LibrarySourceView(source: source)
                                .environmentObject(sourceModel)
                                .environmentObject(navigationStateManager)
                                .environment(\.managedObjectContext, managedObjectContext)
                        case .editClippingView(let clipping):
                            EditClippingView(clipping: clipping)
                                .environmentObject(sourceModel)
                                .environmentObject(navigationStateManager)
                                .environment(\.managedObjectContext, managedObjectContext)
                        default:
                            EmptyView()
                        }
                    }
            }
            .presentationSizing(.page)
        }
    } // View
}


struct LibrarySourceView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LibrarySourceView(source: MockSource())
                .environmentObject(SourceModel())
                .environmentObject(NavigationStateManager())
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        }
    }
}

class MockSource: Source {

    override init() {
        super.init()
        self.title = "Playboy"
        self.year = "1994"
        self.month = "February"
        let clipping1 = Clipping()
        clipping1.id = "1"
        clipping1.imageThumb = UIImage(named: "clippingThumb_1")
        let clipping2 = Clipping()
        clipping2.id = "2"
        clipping2.imageThumb = UIImage(named: "clippingThumb_2")
        let clipping3 = Clipping()
        clipping3.id = "3"
        clipping3.imageThumb = UIImage(named: "clippingThumb_3")
        let clipping4 = Clipping()
        clipping4.id = "4"
        clipping4.imageThumb = UIImage(named: "clippingThumb_4")
        let clipping5 = Clipping()
        clipping5.id = "5"
        clipping5.imageThumb = UIImage(named: "clippingThumb_5")
        
        self.clippings = [clipping1, clipping2, clipping3, clipping4, clipping5]
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
}
