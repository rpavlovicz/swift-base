//
//  EditClippingView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 6/26/25.
//


//
//  EditClippingView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 12/24/23.
//

import SwiftUI

struct EditClippingView: View {
    
    @ObservedObject var clipping: Clipping
    @State var selectedSourceId: String?
    @State private var sourceSearch: String = ""
    @State private var showAcceptScreen: Bool = false
    @State private var sourceChangeAccepted: Bool = false
    
    @State private var isHead: Bool = false
    @State private var isBody: Bool = false
    @State private var isAnimal: Bool = false
    @State private var isMan: Bool = false
    @State private var isWoman: Bool = false
    @State private var isTrans: Bool = false
    @State private var isWhite: Bool = false
    @State private var isBlack: Bool = false
    @State private var isLatino: Bool = false
    @State private var isAsian: Bool = false
    @State private var isIndian: Bool = false
    @State private var isNative: Bool = false
    @State private var isBW: Bool = false
    @State private var name: String = ""
    @State private var tags: [String] = []
    
    @State private var isEditNameSheetPresented = false
    @State private var isEditTagsSheetPresented = false

    
    var hasStateChanged: Bool {
        let sortedCurrentTags = tags.sorted()
        let sortedOriginalTags = clipping.tags.sorted()
        return isHead != clipping.isHead ||
               isBody != clipping.isBody ||
               isAnimal != clipping.isAnimal ||
               isMan != clipping.isMan ||
               isWoman != clipping.isWoman ||
               isTrans != clipping.isTrans ||
               isWhite != clipping.isWhite ||
               isBlack != clipping.isBlack ||
               isLatino != clipping.isLatino ||
               isAsian != clipping.isAsian ||
               isIndian != clipping.isIndian ||
               isNative != clipping.isNative ||
               isBW != clipping.isBlackAndWhite ||
               name != clipping.name ||
               sortedCurrentTags != sortedOriginalTags
    }
    
    @EnvironmentObject var sourceModel: SourceModel
    @EnvironmentObject var navigationStateManager: NavigationStateManager
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    var body: some View {
        
        VStack {
            
            Text("Edit Clipping Info")
                .font(.title3)
                .padding(.top,10)
            Spacer()
            AsyncImage2(clipping: clipping, placeholder: clipping.imageThumb ?? UIImage(), imageUrlMid: clipping.imageUrlMid, frameHeight: 300)
            Spacer()
            TypeSelectorView1(isHead: $isHead, isBody: $isBody, isAnimal: $isAnimal)
                .padding(.horizontal, 20)
            TypeSelectorView2(isMan: $isMan, isWoman: $isWoman, isTrans: $isTrans, isWhite: $isWhite, isBlack: $isBlack, isLatino: $isLatino, isAsian: $isAsian, isIndian: $isIndian, isNative: $isNative, isBW: $isBW)
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
            
            VStack(alignment: .leading, spacing: 10) {
            
                HStack {
                    Text("Source: ").bold()
                    NavigationLink(value: SelectionState.editClippingSourceView(clipping), label: {
                        if let existingSource = sourceModel.getSourceFromID(id: clipping.sourceId) {
                            SourceFormView(source: existingSource)
                        }
                    })
                }
                
                if clipping.isHead && !clipping.isBody {
                    HStack {
                        Text("Name: ").bold()
                        Text("\(name)")
                            .foregroundColor(.blue)
                            .onTapGesture {
                                isEditNameSheetPresented.toggle()
                            }
                            .sheet(isPresented: $isEditNameSheetPresented) {
                                EditNameSheetView(clippingName: clipping.name, editName: $name, isPresented: $isEditNameSheetPresented)
                            }
                            .onChange(of: name) { newName in
                                updateTags(newName: newName)
                            }
                    }
                }
                
                HStack {
                    Text("Tags: ").bold()
                    Text("\(tags.joined(separator: ", "))")
                        .foregroundColor(.blue)
                        .onTapGesture {
                            isEditTagsSheetPresented.toggle()
                        }
                        .sheet(isPresented: $isEditTagsSheetPresented, content: {
                            EditTagsSheetView(tags: $tags, isPresented: $isEditTagsSheetPresented)
                        })
                }
                
                
            } // leading VStack
            
            Spacer()
            
            Button("Edit Clipping") {
                
                // create updated version of the clipping
                var editedClipping = clipping.clone()
                
                if name != clipping.name {
                    print("editedClipping.name changed from cloned value of \(editedClipping.name) to \(name)")
                    editedClipping.name = name
                    print("new editedClipping.name = \(editedClipping.name)")
                }
                if tags != clipping.tags {  // Make sure tags comparison works for your use case (order-sensitive)
                    editedClipping.tags = tags
                }
                if isHead != clipping.isHead {
                    editedClipping.isHead = isHead
                }
                if isBody != clipping.isBody {
                    editedClipping.isBody = isBody
                }
                if isAnimal != clipping.isAnimal {
                    editedClipping.isAnimal = isAnimal
                }
                if isMan != clipping.isMan {
                    editedClipping.isMan = isMan
                }
                if isWoman != clipping.isWoman {
                    editedClipping.isWoman = isWoman
                }
                if isTrans != clipping.isTrans {
                    editedClipping.isTrans = isTrans
                }
                if isWhite != clipping.isWhite {
                    editedClipping.isWhite = isWhite
                }
                if isBlack != clipping.isBlack {
                    editedClipping.isBlack = isBlack
                }
                if isLatino != clipping.isLatino {
                    editedClipping.isLatino = isLatino
                }
                if isAsian != clipping.isAsian {
                    editedClipping.isAsian = isAsian
                }
                if isIndian != clipping.isIndian {
                    editedClipping.isIndian = isIndian
                }
                if isNative != clipping.isNative {
                    editedClipping.isNative = isNative
                }
                if isBW != clipping.isBlackAndWhite {
                    editedClipping.isBlackAndWhite = isBW
                }
                
                sourceModel.updateClipping(editedClipping) { success in
                    if success {
                        sourceModel.updateClippingTagsAndNames(oldName: clipping.name, newName: name, oldTags: clipping.tags, newTags: tags, context: managedObjectContext)
                        navigationStateManager.popBack()
                    }
                }
            }
            .disabled(!hasStateChanged)
            .buttonStyle(ButtonStyle1(inputColor: !hasStateChanged ? .lightGray : .blue))
            .padding(.horizontal, 40)

            
        } // main VStack
        .onAppear {
            isHead = clipping.isHead
            isBody = clipping.isBody
            isAnimal = clipping.isAnimal
            isMan = clipping.isMan
            isWoman = clipping.isWoman
            isTrans = clipping.isTrans
            isWhite = clipping.isWhite
            isBlack = clipping.isBlack
            isLatino = clipping.isLatino
            isAsian = clipping.isAsian
            isIndian = clipping.isIndian
            isNative = clipping.isNative
            isBW = clipping.isBlackAndWhite
            if name.isEmpty {
                name = clipping.name
            }
            if tags.isEmpty {
                tags = clipping.tags
            }
        }
        
        
    } // View
    
    func updateTags(newName: String) {
        if let index = tags.firstIndex(of: clipping.name) {
            tags[index] = newName
        }
    }
    
}


//struct EditClippingView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditClippingView(clipping: MockHeadClipping())
//            .environmentObject(SourceModel())
//            .environmentObject(NavigationStateManager())
//    }
//}
