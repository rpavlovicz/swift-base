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
    
    var body: some View {
        VStack {
            
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
                        NavigationLink(value: SelectionState.clippingsSwipeView(sortedClippings, currentIndex: index), label: { AsyncImage1(clipping: clipping, placeholder: placeholderImage ?? UIImage())})}
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

    } // View
}


//struct LibrarySourceView_Previews: PreviewProvider {
//    static var previews: some View {
//        LibrarySourceView(source: MockSource())
//    }
//}

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
