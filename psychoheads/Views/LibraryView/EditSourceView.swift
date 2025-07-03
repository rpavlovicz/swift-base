//
//  EditSourceView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 6/26/25.
//


//
//  EditSourceView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 4/3/23.
//

import SwiftUI

struct EditSourceView: View {
    
    @EnvironmentObject var sourceModel: SourceModel
    @EnvironmentObject var navigationStateManager: NavigationStateManager
    
    @ObservedObject var source: Source
    @ObservedObject private var sourceCopy: Source
    
    private var isChanged: Bool {
        return sourceCopy.hasChanges(comparedTo: source)
    }
    
    init(source: Source) {
        self.source = source
        self.sourceCopy = Source(copyFrom: source)
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Edit Source")
                .font(.title)
                .padding()

            Text("ncopies")
                .font(.subheadline)
                .padding([.top,.bottom], 5)
            
            HStack {
                Button(action: {
                    withAnimation {
                        if sourceCopy.ncopies > 1 {
                            sourceCopy.ncopies -= 1
                        }
                    }
                }) {
                    Text("-")
                        .font(.largeTitle)
                }
                
                Text("\(sourceCopy.ncopies)")
                    .font(.largeTitle)
                    .id(sourceCopy.ncopies)
                
                Button(action: {
                    withAnimation {
                        sourceCopy.ncopies += 1
                    }
                }) {
                    Text("+")
                        .font(.largeTitle)
                }
                
            }
            
            Button("Edit") {
                if sourceCopy.hasChanges(comparedTo: source) {
                    print("test")
                    sourceModel.editSource(sourceCopy)
                    source.update(from: sourceCopy)
                }
                navigationStateManager.popBack()
            }
            .disabled(!isChanged)
            .buttonStyle(ButtonStyle1(inputColor: isChanged ? .blue : .lightGray))
            .padding(.horizontal, 40)
            
            Button("Cancel") {
                navigationStateManager.popBack()
            }
            .buttonStyle(ButtonStyle1(inputColor: .gray))
            .padding(.horizontal, 40)
            
            Spacer()
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Passed Source").font(.title2)
                    Text("title = \(source.title)")
                    Text("type = \(source.type)")
                    Text("year = \(source.year)")
                    Text("month = \(source.month ?? "")")
                    Text("issue = \(source.issue ?? "")")
                    Text("day = \(source.day ?? "")")
                    Text("ncopies = \(source.ncopies)")
                }
                .padding(.leading)
                Spacer()
                VStack(alignment: .leading) {
                    Text("Copied Source").font(.title2)
                    Text("title = \(sourceCopy.title)")
                    Text("type = \(sourceCopy.type)")
                    Text("year = \(sourceCopy.year)")
                    Text("month = \(sourceCopy.month ?? "")")
                    Text("issue = \(sourceCopy.issue ?? "")")
                    Text("day = \(sourceCopy.day ?? "")")
                    Text("ncopies = \(sourceCopy.ncopies)")
                }
                .padding(.leading)
            }
            Text("isChanged = \(String(isChanged))")
            Text("navigationStateManager count = \(navigationStateManager.selectionPath.count)")
            
            
            
        } // VStack
        .navigationBarBackButtonHidden(true)
    }
}

//struct EditSourceView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditSourceView(source: Source())
//            .environmentObject(SourceModel())
//            .environmentObject(NavigationStateManager())
//    }
//}
