//
//  EditNameSheetView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 6/26/25.
//

import SwiftUI
import CoreData

struct EditNameSheetView: View {
    
    var clippingName: String
    @Binding var editName: String
    @Binding var tags: [String]
    @Binding var isPresented: Bool
    
    @State private var localEditName: String
    
    @Environment(\.managedObjectContext) private var managedObjectContext
    @EnvironmentObject private var sourceModel: SourceModel
    
    @FetchRequest(
        entity: HeadName.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \HeadName.count, ascending: false)]
    )
    private var headNames: FetchedResults<HeadName>
    
    @FocusState private var isNameFieldFocused: Bool
    
    private var existingHeadNames: [String] {
        headNames.compactMap { $0.name }.filter { !$0.isEmpty }
    }
    
    private var filteredHeadNames: [String] {
        existingHeadNames.filter { head in
            localEditName.isEmpty || head.lowercased().contains(localEditName.lowercased())
        }
    }
    
    init(clippingName: String, editName: Binding<String>, tags: Binding<[String]>, isPresented: Binding<Bool>) {
        self.clippingName = clippingName
        self._editName = editName
        self._tags = tags
        self._isPresented = isPresented
        _localEditName = State(initialValue: editName.wrappedValue)
    }
    
    var body: some View {
        VStack {
            Text("Edit Clipping Name")
                .font(.title3)
                .padding(.vertical, 30)
            
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Original clipping name: ").bold()
                    Text(clippingName)
                }
                
                HStack {
                    Text("New name: ").bold()
                    TextField("Name", text: $localEditName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocorrectionDisabled(true)
                        .focused($isNameFieldFocused)
                        .overlay(
                            Group {
                                if !localEditName.isEmpty {
                                    Button {
                                        localEditName = ""
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.gray)
                                    }
                                    .padding(.vertical)
                                }
                            },
                            alignment: .trailing
                        )
                        .onSubmit {
                            applyTypedNameSubmission()
                        }
                }
                
                if isNameFieldFocused && !filteredHeadNames.isEmpty {
                    Text("Existing names")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 8) {
                            ForEach(filteredHeadNames, id: \.self) { headName in
                                TagView2(tag: headName) {
                                    applySelectedHeadName(headName)
                                }
                            }
                        }
                    }
                    .frame(maxHeight: 44)
                }
                
                Spacer()
                
                Button("Accept") {
                    let trimmed = localEditName.trimmingCharacters(in: .whitespacesAndNewlines)
                    localEditName = trimmed
                    syncTagsForNewName(trimmed)
                    editName = trimmed
                    isPresented = false
                }
                .buttonStyle(ButtonStyle1(inputColor: .blue))
                .padding(.top, 20)
            }
            .padding(.horizontal, 20)
            Spacer()
        }
    }
    
    private func applySelectedHeadName(_ headName: String) {
        let trimmed = headName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        localEditName = trimmed
        syncTagsForNewName(trimmed)
        isNameFieldFocused = false
    }
    
    private func applyTypedNameSubmission() {
        localEditName = localEditName.trimmingCharacters(in: .whitespacesAndNewlines)
        syncTagsForNewName(localEditName)
    }
    
    /// Match AddClippingView: keep tags in sync with the chosen name and merge aggregated tags from the DB.
    private func syncTagsForNewName(_ trimmed: String) {
        guard !trimmed.isEmpty else { return }
        if let index = tags.firstIndex(of: clippingName) {
            tags[index] = trimmed
        }
        if !tags.contains(trimmed) {
            tags.append(trimmed)
        }
        let autoPopulatedTags = sourceModel.aggregatedTagsForName(trimmed)
        for tag in autoPopulatedTags where !tags.contains(tag) {
            tags.append(tag)
        }
    }
}

// MARK: - Previews

struct EditNameSheetView_Previews: PreviewProvider {
    static var previews: some View {
        EditNameSheetViewPreviewHost()
            .previewDisplayName("Edit name sheet")
    }
}

private struct EditNameSheetViewPreviewHost: View {
    private static let previewContext: NSManagedObjectContext = {
        let pc = PersistenceController(inMemory: true)
        let ctx = pc.container.viewContext
        let sampleNames = ["Ada Lovelace", "Grace Hopper", "Anna Nicole Smith", "Marilyn Monroe"]
        for (i, name) in sampleNames.enumerated() {
            let hn = HeadName(context: ctx)
            hn.name = name
            hn.count = Int64(20 - i)
        }
        try? ctx.save()
        return ctx
    }()

    @State private var editName = "Anna Nicole Smith"
    @State private var tags = ["Anna Nicole Smith", "blonde", "Playboy"]
    @State private var isPresented = true

    var body: some View {
        EditNameSheetView(clippingName: "Anna Nicole Smith", editName: $editName, tags: $tags, isPresented: $isPresented)
            .environmentObject(SourceModel())
            .environment(\.managedObjectContext, Self.previewContext)
    }
}
