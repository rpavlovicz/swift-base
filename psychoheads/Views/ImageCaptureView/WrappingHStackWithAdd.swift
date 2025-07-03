//
//  WrappingHStackWithAdd.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 6/26/25.
//


//
//  WrappingHStackWithAdd.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 12/25/23.
//


import SwiftUI

struct WrappingHStackWithAdd: View {
    @Binding var items: [String]
    @Binding var showTextField: Bool
    @State private var newTagText: String = ""
    @FocusState private var isTextFieldFocused: Bool // FocusState variable
    @FetchRequest(entity: ClippingTag.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \ClippingTag.count, ascending: false)]) var clippingTags: FetchedResults<ClippingTag>
    
    var existingTags: [String] {
        clippingTags.map { $0.tagString ?? "" }
    }
    
    let horizontalSpacing: CGFloat = 8
    let verticalSpacing: CGFloat = 8
    @State private var toggledTag: String?
    
    @State private var calculatedHeight: CGFloat = 0
    
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
        
        let allItems = ["+"] + items
        
        var finalheight: CGFloat = 0
        var finalheight2: CGFloat = 0
        var width: CGFloat = 0
        var height: CGFloat = 0
        //let rowHeight: CGFloat = 28.333
//        @State var nRows: CGFloat = 1
        
        //calculatedHeight = rowHeight
        //print("entering generateContent")
        //print("calculated height = \(calculatedHeight)")
        return ZStack(alignment: .topLeading) {
            ForEach(allItems, id: \.self) { item in
                if item == "+" {
                    TagView2(tag: item, onTagTapped: {
                        showTextField = true
                    })
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
                } else {
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
                        .alignmentGuide(.top, computeValue: { d in
                            let result = height
                            if item == items.last {
                                finalheight = height - d.height - verticalSpacing
                                finalheight2 = height - 2*d.height - 2*verticalSpacing
                                height = 0
                            }
                            //print("top alignment for \(item) = \(height)")
                            return result
                        })
                }
                
            } // ForEach
            
            if showTextField {
                TextField("New tag", text: $newTagText, onCommit: {
                    newTagText = newTagText.trimmingCharacters(in: .whitespacesAndNewlines)
                    if !newTagText.isEmpty {
                        items.append(newTagText)
                        newTagText = ""
                        showTextField = false
                    }
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .focused($isTextFieldFocused) // Set focus using FocusState
                .onAppear {
                    isTextFieldFocused = true // Automatically focus when TextField appears
                    newTagText = ""
                }
                .alignmentGuide(.leading) { _ in
                    0
                }
                .alignmentGuide(.top, computeValue: { _ in
                    let result = finalheight
                    //height = 50
                    //print("top alignment for \(item) = \(height)")
                    return result
                })
            }
            
            let sortedTags = existingTags.filter({ sourceText in newTagText == "" ? true : sourceText.lowercased().contains(newTagText.lowercased())})
            
            if (showTextField && !sortedTags.isEmpty) {
                ScrollView(.horizontal) {
                    LazyHStack {
                        ForEach(sortedTags, id: \.self) { tag in
                            if !items.contains(tag) {
                                TagView2(tag: tag) {
                                    items.append(tag)
                                    newTagText = ""
                                    isTextFieldFocused = false
                                    showTextField = false
                                }
                            }
                        }
                    }
                    .frame(height: 30)
                    
                }
                .alignmentGuide(.top, computeValue: { _ in
                    let result = finalheight2
                    return result
                })
            }
            
        }
    }
    
}

//struct WrappingHStackWithAdd_Previews: PreviewProvider {
//
//    struct Preview: View {
//        @State var previewTags = ["test", "test2", "fdsafsdf", "framesize_352", "Test234567", "continue testing", "why doesn't it", "always work?", "another test", "123125", "overflow"]
//        @State var showField = false
//        
//        var body: some View {
//            WrappingHStackWithAdd(items: $previewTags, showTextField: $showField)
//        }
//    }
//    
//    static var previews: some View {
//        Preview()
//            .previewLayout(.sizeThatFits)
//    }
//}
