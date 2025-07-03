//
//  EditClippingSourceView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 6/26/25.
//


//
//  EditClippingView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 7/7/23.
//

import SwiftUI

struct EditClippingSourceView: View {
    
    var clipping: Clipping
    @State var selectedSourceId: String?
    @State private var sourceSearch: String = ""
    @State private var showAcceptScreen: Bool = false
    @State private var sourceChangeAccepted: Bool = false
    
    @EnvironmentObject var sourceModel: SourceModel
    @EnvironmentObject var navigationStateManager: NavigationStateManager
    
    var body: some View {
        ZStack {
            VStack {
                HStack(alignment: .center) {
                    Spacer()
                    Image(uiImage: clipping.imageThumb!)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                    Spacer()
                    VStack(alignment: .center) {
                        Text("Current Source:")
                            .font(.subheadline)
                        if let existingSource = sourceModel.getSourceFromID(id: clipping.sourceId) {
                            VerticalSourceView(source: existingSource)
                        }
                    }
                    Spacer()
                } // HStack
                .padding(.bottom, 10)
                
                
                VStack {
                    TextField("New Source", text: $sourceSearch)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .foregroundColor(Color.black)
                        .padding(.horizontal, 19)
                        .padding(.top, 20)
                        .overlay(
                            Group {
                                if !sourceSearch.isEmpty {
                                    Button(action: {
                                        sourceSearch = ""
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.gray)
                                            .padding(.trailing, 20)
                                    }
                                    .padding(.vertical)
                                    .padding(.trailing)
                                    .padding(.top, 20)
                                }
                            },
                            alignment: .trailing
                        )
                    
                    let sortedSources = sourceModel.sources.filter({ sourceText in
                        if sourceSearch == "" {
                            return sourceText.id != clipping.sourceId
                        } else {
                            return sourceText.title.lowercased().contains(sourceSearch.lowercased()) && sourceText.id != clipping.sourceId
                        }
                    })
                    
                    List(selection: $selectedSourceId) {
                        ForEach(sortedSources, id: \.id) { source in
                            SourceRowView(source: source, displayMode: .thumbnail)
                                .onTapGesture {
                                    if selectedSourceId == source.id     {
                                        selectedSourceId = nil // deselect source
                                    } else {
                                        selectedSourceId = source.id
                                    }
                                }
                        }
                    }.frame(height: 300)
                    
                } // search VStack
                .background(Color(.systemGray6)) // set VStack background
                
                Spacer()
                
                Button("Edit Source") {
                    print("edit button pressed")
                    showAcceptScreen.toggle()
                    print("showAcceptScreen = \(showAcceptScreen)")
                    print("selectedSourceId = \(selectedSourceId)")
                }
                .disabled(selectedSourceId == nil)
                .buttonStyle(ButtonStyle1(inputColor: selectedSourceId == nil ? .lightGray : .blue))
                .padding(.horizontal, 40)
                
                //Spacer()
            } // main VStack
            .blur(radius: showAcceptScreen ? 4 : 0)
            .onChange(of: sourceChangeAccepted) { newValue in
                if newValue == true {
                    navigationStateManager.popBack()
                }
            }
            
            if showAcceptScreen {
                acceptClippingSourceEditView(showAcceptScreen: $showAcceptScreen, sourceChangeAccepted: $sourceChangeAccepted, clipping: clipping, newSourceId: selectedSourceId!)
                    .environmentObject(sourceModel)
            }
            
        } // ZStack
        
        
    } // View
}

// MARK: - accept screen

struct acceptClippingSourceEditView: View {
    
    @Binding var showAcceptScreen: Bool
    @Binding var sourceChangeAccepted: Bool
    var clipping: Clipping
    var newSourceId: String
    
    @EnvironmentObject var sourceModel: SourceModel
    
    var currentSource: Source? {
        sourceModel.getSourceFromID(id: clipping.sourceId)
    }

    var newSource: Source? {
        sourceModel.getSourceFromID(id: newSourceId)
    }
    
    var body: some View {
        VStack {
            
            Text("Change Clipping Source")
                .padding(.vertical, 10)
            Spacer()
            
            HStack(alignment: .top) {
                
                Spacer()
                VStack {
                    Text("Current Source:")
                    VerticalSourceView(source: currentSource)
                }
                Spacer()
                VStack {
                    Text("New Source:")
                    VerticalSourceView(source: newSource)
                }
                Spacer()
            }
            
            Spacer()
            
            HStack {
                Spacer()
                Button("OK") {
                    if let currentSource = sourceModel.getSourceFromID(id: clipping.sourceId),
                       let newSource = sourceModel.getSourceFromID(id: newSourceId),
                       let currentIndex = currentSource.clippings.firstIndex(of: clipping) {
                        
                        // Modify the sourceId of the Clipping object
                        clipping.sourceId = newSourceId
                        
                        // Remove the clipping from the current source's clippings array
                        currentSource.clippings.remove(at: currentIndex)
                        
                        // Add the clipping to the new source's clippings array
                        newSource.clippings.append(clipping)
                        
                        // Call a method to update the source models
                        // This will depend on how your SourceModel is structured
                        sourceModel.updateSource(currentSource) { success in
                            if success {
                                sourceModel.updateSource(newSource) { success in
                                    if success {
                                        sourceChangeAccepted = true
                                        showAcceptScreen.toggle()
                                    } else {
                                        // Handle failure here
                                    }
                                }
                            } else {
                                // Handle failure here
                            }
                        }
                    }
                }
                .frame(width: 80, height: 50)
                Spacer()
                Button("Cancel") {
                    showAcceptScreen.toggle()
                }
                .frame(width: 80, height: 50)
                Spacer()
            }
            
            
        }.frame(width: UIScreen.main.bounds.width-50, height: 300)
            .background(Color.white.opacity(0.9))
            .cornerRadius(12)
            .clipped()
    }
}

//struct EditClippingSourceView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditClippingSourceView(clipping: MockClipping())
//            .environmentObject(SourceModel())
//            .environmentObject(NavigationStateManager())
//    }
//}

