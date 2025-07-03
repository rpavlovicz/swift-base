//
//  LibraryView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 6/25/25.
//


//
//  LibraryView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 3/24/23.
//

import SwiftUI
import FirebaseFirestore

struct LibraryView: View {
    
    enum Field: Hashable {
        case sourceSearchField
    }
    
    // why pass this explicitly as an ObservedObject instead if implicitly as an
    //  @EnvironmentObject var sourceModel: SourceModel
    @ObservedObject var sourceModel: SourceModel

    @AppStorage("isThumbnailMode") private var isThumbnailMode: Bool = false
    
    @State private var showAlert = false
    @State private var sourceToDelete: Source?
    @State private var sourceToEdit: Source?
    @State private var editActive = false
    
    @State var searchText: String = ""
    @State private var isTagSearchActive: Bool = false
    @FocusState private var focusedField: Field?
    
    // Grid layout properties
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @State private var isLandscape: Bool = false
    
    var isIPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var shouldUseGrid: Bool {
        return isIPad && isLandscape
    }
    
    var filteredSources: [Source] {
        let filtered = sourceModel.sources.filter { source in
            searchText.isEmpty || source.title.lowercased().contains(searchText.lowercased())
        }
        return filtered.sorted {
            if $0.title != $1.title {
                return $0.title < $1.title
            } else {
                return $0.year < $1.year
            }
        }
    }
    
    // Grid layout for iPad landscape
    var gridLayout: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ], spacing: 16) {
                ForEach(filteredSources) { source in
                    NavigationLink(value: SelectionState.sourceView(source)) {
                        SourceCardView(source: source)
                            .environmentObject(source)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
        }
        .refreshable {
            sourceModel.updateSources()
        }
    }
    
    // Card view for grid layout
    struct SourceCardView: View {
        let source: Source
        let placeholderImage: UIImage? = UIImage(named: "source_thumb")
        @StateObject private var imageLoader = ImageLoader()
        
        var body: some View {
            ZStack(alignment: .leading) {
                HStack(spacing: 20) {
                    if source.imageThumb != nil {
                        Image(uiImage: source.imageThumb!)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                    } else {
                        if let image = placeholderImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(source.title)
                            .font(.headline)
                            .lineLimit(2)
                        if let issue = source.issue, !issue.isEmpty {
                            Text(source.issue!)
                                .font(.subheadline)
                                .lineLimit(1)
                        }
                        Text(source.dateString)
                            .font(.subheadline)
                            .lineLimit(1)
                        Text("Number of clippings: \(source.clippings.count)")
                            .font(.footnote)
                            .lineLimit(1)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 120)
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(8)
            .shadow(radius: 1)
            .onAppear {
                if source.imageThumb == nil {
                    print("source.imageThumb was nil... loading image")
                    imageLoader.load(imagePath: source.imageUrlThumb, useCache: true) { success, downloadedImage in
                        if success, let validImage = downloadedImage {
                            source.imageThumb = downloadedImage
                        } else {
                            source.imageThumb = UIImage(named: "broken_image_link")
                        }
                    }
                }
            }
        }
    }
    
    var body: some View {
        VStack {
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
                .focused($focusedField, equals: .sourceSearchField)
                .onChange(of: focusedField) { newValue in
                    isTagSearchActive = (newValue == .sourceSearchField)
                }
            
            if shouldUseGrid {
                // Grid layout for iPad landscape
                gridLayout
            } else {
                // List layout for portrait and smaller screens
                List {
                    ForEach(filteredSources) { source in
                        NavigationLink(value: SelectionState.sourceView(source), label: {
                            SourceRowView2(source: source, displayMode: isThumbnailMode ? .thumbnail : .minimal)
                                .environmentObject(source)
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    NavigationLink(value: SelectionState.edit(source), label: { Label("Edit", systemImage: "pencil")})
                                        .tint(.blue)

                                    Button(role: .destructive) {
                                        sourceToDelete = source
                                        showAlert = true
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                        })
                    }
                }
                .navigationBarTitle("", displayMode: .inline)
                .refreshable {
                    sourceModel.updateSources()
                }
                .listStyle(.plain)
            }

            Spacer()
            
            HStack {
                Text("Number of sources: \(filteredSources.count)")
                Spacer()
                if !shouldUseGrid {
                    Toggle(isOn: $isThumbnailMode) {}
                        .tint(.blue)
                        .frame(width: 70)
                    Image(systemName: "rectangle.expand.vertical")
                        .font(Font.system(size: 15))
                        .padding(.leading, 1)
                }
            }.padding([.leading, .trailing],20)
            
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Delete Source"),
                  message: Text("Are you sure you want to delete this source from the database?"),
                  primaryButton: .destructive(Text("Delete")) {
                if let source = sourceToDelete {
                    sourceModel.deleteSource(source)
                }
            },
                  secondaryButton: .cancel()
            )
        }
        .onAppear {
            // Check initial orientation
            isLandscape = UIDevice.current.orientation.isLandscape
        }
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            // Update orientation when device rotates
            isLandscape = UIDevice.current.orientation.isLandscape
        }
    }
    
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LibraryView(sourceModel: {
                let model = SourceModel()
                // Add some sample sources for preview
                let source1 = Source(title: "Sample Magazine", year: "2023", month: "January")
                source1.id = "1"
                
                let source2 = Source(title: "Another Source", year: "2022", month: "December")
                source2.id = "2"
                
                let source3 = Source(title: "Test Publication", year: "2024", month: "March")
                source3.id = "3"
                
                let source4 = Source(title: "Vintage Collection", year: "1995", month: "August")
                source4.id = "4"
                
                let source5 = Source(title: "Modern Times", year: "2023", month: "November")
                source5.id = "5"
                
                let source6 = Source(title: "Classic Edition", year: "2000", month: "April")
                source6.id = "6"
                
                model.sources = [source1, source2, source3, source4, source5, source6]
                return model
            }())
            .environmentObject(NavigationStateManager())
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        }
    }
}
