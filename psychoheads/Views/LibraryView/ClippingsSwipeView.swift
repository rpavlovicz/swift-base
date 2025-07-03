//
//  ClippingsSwipeView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 6/26/25.
//


//
//  ClippingsSwipeView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 1/7/24.
//


import SwiftUI
import CoreData

struct ClippingsSwipeView: View {
    
    var clippings: [Clipping]
    @State var currentIndex: Int
    
    @EnvironmentObject var sourceModel: SourceModel
    @EnvironmentObject var navigationStateManager: NavigationStateManager

    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State private var showAlert = false
    @State private var clippingToDelete: Clipping?
    
    @State private var expanded: Bool = false
    
    var body: some View {
        let clipping = clippings[currentIndex]
        let source = sourceModel.sources.first { $0.id == clippings[currentIndex].sourceId }
        
        VStack {
            
            AsyncImage2(clipping: clipping, placeholder: clipping.imageThumb ?? UIImage(), imageUrlMid: clipping.imageUrlMid, frameHeight: 450)
                .padding(.vertical)
                .padding(.horizontal)
                .gesture(DragGesture(minimumDistance: 3.0, coordinateSpace: .local)
                    .onEnded { value in
                        if value.translation.width < 0 && currentIndex < clippings.count - 1 {
                            currentIndex += 1
                        } else if value.translation.width > 0 && currentIndex > 0 {
                            currentIndex -= 1
                        }
                    }
                )
            
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    
                    HStack(alignment: .top) {
                        Text("Source: ").bold()
                        if let source = source {
                            NavigationLink(value: SelectionState.sourceView(source), label: {
                                SourceFormView(source: source)
                            })
//                            VStack(alignment: .leading) {
//                                Text(source.title)
//                                    .fontWeight(.semibold)
//                                if let issue = source.issue, !issue.isEmpty {
//                                    Text(source.issue!)
//                                        .font(.subheadline)
//                                }
//                                Text(source.dateString)
//                                    .font(.subheadline)
//                            }
                        }
                    }
                    
                    if clipping.isHead && !clipping.isBody {
                        let clippingNameSource = sourceModel.createSourceFromClippingName(clippingName: clipping.name)
                        HStack {
                            Text("Name: ").bold()
                            NavigationLink(value: SelectionState.sourceView(clippingNameSource), label: {
                                Text("\(clipping.name)")
                                }
                            )
                        }
                    }

                    Text("Date Added: ").bold() + Text("\(formatDate(date: clipping.added))")
                    Text("Tags: ").bold() + Text("\(clipping.tags.joined(separator: ", "))")
                    DisclosureGroup("additional information", isExpanded: $expanded) {
                        
                        HStack {
                            Spacer()
                            VStack(alignment: .leading) {
                                Text("height = \(String(format: "%.2f", clipping.height)) cm")
                                    .font(.subheadline)
                                if clipping.headHeight == nil {
                                    Text("head height = N/A")
                                        .font(.subheadline)
                                } else {
                                    Text("head height = \(String(format: "%.2f", clipping.headHeight!)) cm")
                                        .font(.subheadline)
                                }
                            }
                            Spacer()
                            VStack(alignment: .leading) {
                                Text("width = \(String(format: "%.2f", clipping.width)) cm")
                                    .font(.subheadline)
                                if clipping.headWidth == nil {
                                    Text("head width = N/A")
                                        .font(.subheadline)
                                } else {
                                    Text("head width = \(String(format: "%.2f", clipping.headWidth!)) cm")
                                        .font(.subheadline)
                                }
                            }
                            Spacer()
                        }
                        .padding(.vertical, 5)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            if (clipping.isHead && !clipping.isBody) {
                                Text("lookingDirection: \(clipping.lookingDirection ?? "")")
                                    .font(.subheadline)

                            }
                            Text("id: \(clipping.id)")
                                .font(.subheadline)
                            Text("source id: \(clipping.sourceId)")
                                .font(.subheadline)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack {
                            Spacer()
                            VStack(alignment: .leading) {
                                Text("isHead = \(String(clipping.isHead))")
                                Text("isBody = \(String(clipping.isBody))")
                                Text("isAnimal = \(String(clipping.isAnimal))")
                                Text("isMan = \(String(clipping.isMan))")
                                Text("isWoman = \(String(clipping.isWoman))")
                                Text("isTrans = \(String(clipping.isTrans))")
                            }
                            Spacer()
                            VStack(alignment: .leading) {
                                Text("isWhite = \(String(clipping.isWhite))")
                                Text("isBlack = \(String(clipping.isBlack))")
                                Text("isLatino = \(String(clipping.isLatino))")
                                Text("isAsian = \(String(clipping.isAsian))")
                                Text("isNative = \(String(clipping.isNative))")
                                Text("isIndian = \(String(clipping.isIndian))")
                                Text("isB&W = \(String(clipping.isBlackAndWhite))")
                            }
                            Spacer()
                        }
                        .padding(.vertical, 5)
                        
//                        VStack(alignment: .leading, spacing: 5) {
//                            Text("image ULR = \(clipping.imageUrl)")
//                            Text("image ULR (mid) = \(clipping.imageUrlMid)")
//                            Text("image ULR (thumb) = \(clipping.imageUrlThumb)")
//                        }
//                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Spacer()
                        
                        NavigationLink(value: SelectionState.editClippingView(clipping), label: {
                            Label("Edit Clipping", systemImage: "pencil")
                        })
                            
                        Button(role: .destructive) {
                            clippingToDelete = clipping
                            showAlert = true
                        } label: {
                            Label("Delete Clipping", systemImage: "trash")
                        }
                        .padding(.vertical,10)
                        
                    } // DisclosureGroup
                } // text VStack
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .padding(.horizontal, 10)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray5)))
            }
                
            
        } // main view VStack
        .padding(.horizontal, 10)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Delete Clipping"),
                  message: Text("Are you sure you want to delete this clipping from the database?"),
                  primaryButton: .destructive(Text("Delete")) {
                if let clipping = clippingToDelete {
                    sourceModel.deleteClipping(clipping)
                    // navigate back
                    navigationStateManager.popBack()
                }
                updateClippingTags(clipping: clipping)
                updateHeadNameData(clipping: clipping)
            },
                  secondaryButton: .cancel()
            )
        }
        
    }

    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    func updateClippingTags(clipping: Clipping) {
        for tag in clipping.tags {
            let fetchRequest: NSFetchRequest<ClippingTag> = ClippingTag.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "tagString == %@", tag)
            
            do {
                let matchingTags = try managedObjectContext.fetch(fetchRequest)
                for matchingTag in matchingTags {
                    if matchingTag.count > 1 {
                        print("decrementing \(matchingTag.tagString!) ClippingTag count by 1")
                        matchingTag.count -= 1
                    } else {
                        print("deleting \(matchingTag.tagString!) ClippingTag from Core Data")
                        managedObjectContext.delete(matchingTag)
                    }
                }
                try managedObjectContext.save()
            } catch {
                print("Failed to fetch or save clipping tag in Core Data: \(error)")
            }
        }
    }
    
    func updateHeadNameData(clipping: Clipping) {
        
        let fetchRequest: NSFetchRequest<HeadName> = HeadName.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", clipping.name)
        
        do {
            let matchingNames = try managedObjectContext.fetch(fetchRequest)
            for matchingName in matchingNames {
                if matchingName.count > 1 {
                    print("decrementing \(matchingName.name!) HeadName count by 1")
                    matchingName.count -= 1
                } else {
                    print("deleting \(matchingName.name!) HeadName from Core Data")
                    managedObjectContext.delete(matchingName)
                }
            }
            try managedObjectContext.save()
        } catch {
            print("Failed to fetch or save head name in Core Data: \(error)")
        }
        
    }

    
}

//
//struct ClippingsSwipeView_Previews: PreviewProvider {
//    static var previews: some View {
//        ClippingsSwipeView(clippings: [MockClipping(), MockHeadClipping()], currentIndex: 1)
//            .environmentObject(SourceModel())
//            .environmentObject(NavigationStateManager())
//    }
//}





