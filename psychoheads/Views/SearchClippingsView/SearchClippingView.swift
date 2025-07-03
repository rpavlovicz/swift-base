//
//  SearchClippingView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 6/27/25.
//


//
//  SearchClippingView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 6/21/23.
//

import SwiftUI
import CoreData

struct SearchClippingView: View {
    
    enum Field: Hashable {
        case tagSearchField
    }
    
    @EnvironmentObject var sourceModel: SourceModel
    @EnvironmentObject var navigationStateManager: NavigationStateManager
    
    @State var searchText: String = ""
    @State private var isTagSearchActive: Bool = false
    @State private var expandSheet: Bool = false
    
    @State private var searchHeads: Bool = true
    @State private var searchTags: Bool = false
    @State private var lookingDirection: LookingDirection?
    
    let placeholderImage: UIImage? = UIImage(named: "clipping_thumb")
    
    @FocusState private var focusedField: Field?
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: ClippingTag.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \ClippingTag.count, ascending: false)]) var clippingTags: FetchedResults<ClippingTag>
    
    @FetchRequest(entity: HeadName.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \HeadName.count, ascending: false)]) var headNames: FetchedResults<HeadName>
    
    var existingTags: [String] {
        clippingTags.map { $0.tagString ?? "" }
    }
    
    var existingHeadNames: [String] {
        headNames.map { $0.name ?? "" }
    }
    
    var clippings: [Clipping]? = nil
    
//    var filteredClippings: [Clipping] {
//        if let clippings = clippings {
//            return clippings
//        } else {
//            return sourceModel.sources.flatMap { $0.clippings }
//                .filter { clipping in
//                    let nameMatch = searchHeads && clipping.name.lowercased().contains(searchText.lowercased())
//                    let tagMatch = searchTags && clipping.tags.contains { tag in
//                        tag.lowercased().contains(searchText.lowercased())
//                    }
//                    let directionMatch = (clipping.isHead && !clipping.isBody) && (lookingDirection == nil || clipping.lookingDirection == lookingDirection?.rawValue)
//                    return (nameMatch || tagMatch) && (!clipping.isHead || directionMatch)
//                }
//        }
//    }
    
    var filteredClippings: [Clipping] {
        if let clippings = clippings {
            // Apply directionMatch filter specifically to the provided clippings
            return clippings.filter { clipping in
                let directionMatch = (clipping.isHead && !clipping.isBody) && (lookingDirection == nil || clipping.lookingDirection == lookingDirection?.rawValue)
                return !clipping.isHead || directionMatch
            }
        } else {
            return sourceModel.sources.flatMap { $0.clippings }
                .filter { clipping in
                    let nameMatch = searchHeads && clipping.name.lowercased().contains(searchText.lowercased())
                    let tagMatch = searchTags && clipping.tags.contains { tag in
                        tag.lowercased().contains(searchText.lowercased())
                    }
                    let directionMatch = (clipping.isHead && !clipping.isBody) && (lookingDirection == nil || clipping.lookingDirection == lookingDirection?.rawValue)
                    return (nameMatch || tagMatch) && (!clipping.isHead || directionMatch)
                }
        }
    }
    
    var body: some View {
        
        VStack {
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                    ForEach(filteredClippings, id: \.id) { clipping in
                        
                        NavigationLink(value: SelectionState.clippingView(clipping), label: {
                            AsyncImage1(clipping: clipping, placeholder: placeholderImage ?? UIImage())
                        })
                        
                    }
                }
            }
            .padding(.horizontal)// ScrollView
            
            Spacer()
            
            // MARK: - expandable sheet
            Button {
                expandSheet.toggle()
            } label: {
                Image(systemName: "chevron.compact.up")
            }
            .padding(.bottom, 5)
            .sheet(isPresented: $expandSheet) {
                
                Form {
                    Section(header: Text("Search Type")) {
                        SearchSelectorView1(searchHeads: $searchHeads, searchTags: $searchTags, lookingDirection: $lookingDirection)
                    }
                }
                .background(Color.clear) // Set the background to clear
                .presentationDetents([.medium, .large])
            }
            .background(Color.clear) // Set the background to clear

            
            // MARK: - filter search results
            let sortedHeadNames = existingHeadNames.filter({ sourceText in searchText == "" ? true : sourceText.lowercased().contains(searchText.lowercased())})
            
            if (isTagSearchActive && !sortedHeadNames.isEmpty) {
                ScrollView(.horizontal) {
                    LazyHStack {
                        ForEach(sortedHeadNames, id: \.self) { headName in
                            TagView2(tag: headName) {
                                searchText = headName
                                focusedField = nil
                            }
                        }
                    }
                    .padding(.leading, 20)
                    .frame(height: 30)
                }
            }
            
            // MARK: - search bar
            TextField("Search", text: $searchText)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .padding()
                .padding(.top, -10)
                .overlay(
                    Group {
                        if !searchText.isEmpty {
                            Button(action: {
                                searchText = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 10)
                            }
                            .padding(.vertical)
                            .padding(.trailing)
                            .padding(.top, -10)
                        }
                    },
                    alignment: .trailing
                )
                .focused($focusedField, equals: .tagSearchField)
                .onChange(of: focusedField) { newValue in
                    isTagSearchActive = (newValue == .tagSearchField)
                }
            
        } // main VStack
        
        
    }
}

//struct SearchClippingView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        SearchClippingView()
//            .environmentObject(SourceModel())
//            .environmentObject(NavigationStateManager())
//    }
//}

