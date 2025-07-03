//
//  WrappingHStack.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 6/27/25.
//


//
//  WrappingHStack.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 5/6/23.
//

import SwiftUI

struct WrappingHStack: View {
    @State var items: [String]
    let horizontalSpacing: CGFloat = 8
    let verticalSpacing: CGFloat = 8
    @State private var toggledTag: String?
    
    @State private var calculatedHeight: CGFloat = 0
    
//    init(items: [String], horizontalSpacing: CGFloat = 8, verticalSpacing: CGFloat = 8) {
//        self.items = items
//        self.horizontalSpacing = horizontalSpacing
//        self.verticalSpacing = verticalSpacing
//    }
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                self.generateContent(in: geometry)
            }
        }
        //.frame(height: calculatedHeight)
        
    }

    //@State private var nRows: CGFloat = 1
    
    private func generateContent(in geometry: GeometryProxy) -> some View {
        var width: CGFloat = 0
        var height: CGFloat = 0
        //let rowHeight: CGFloat = 28.333
//        @State var nRows: CGFloat = 1
        
        //calculatedHeight = rowHeight
        //print("entering generateContent")
        //print("calculated height = \(calculatedHeight)")
        return ZStack(alignment: .topLeading) {
            ForEach(items, id: \.self) { item in
                TagView(tag: item, onDelete: {
                    if let index = items.firstIndex(of: item) {
                        items.remove(at: index)
                        toggledTag = nil
                    }
                }, toggledTag: $toggledTag)
                    .alignmentGuide(.leading, computeValue: { d in
                        
                        if (abs(width - d.width) > geometry.size.width) {
                            width = 0
                            height -= d.height + verticalSpacing
                            //nRows += 1
                        }
                        let result = width
                        if item == items.last {
                            width = 0
                        } else {
                            width -= d.width + horizontalSpacing
                        }
                        //print("\n \(items.firstIndex(of: item))")
                        //print("leading alignment for \(item) = \(width)")
                        return result
                    })
                    .alignmentGuide(.top, computeValue: { _ in
                        let result = height
                        if item == items.last {
                            height = 0
                        }
                        //print("top alignment for \(item) = \(height)")
                        return result
                    })
            }
            
        }
    }
    
//    func itemBuilder(_ tag: String) -> some View {
//        Text(tag)
//            .padding(.horizontal, 8)
//            .padding(.vertical, 4)
//            .background(Color(.systemGray5))
//            .clipShape(Capsule())
//    }
}

//struct WrappingHStack_Previews: PreviewProvider {
//
//    static var previews: some View {
//        WrappingHStack(items: ["test", "test2", "fdsafsdf", "framesize_352", "Test234567", "continue testing", "why doesn't it", "always work?", "another test", "123125", "overflow"])
//    }
//}
