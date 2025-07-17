//
//  SideMenuView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 6/27/25.
//

import SwiftUI

// Side Menu Content View with draggable clipping list
struct SideMenuView: View {
    @Binding var presentSideMenu: Bool
    @Binding var clippings: [Clipping] // The loaded clippings from CollageView
    let menuWidth: CGFloat // Width of the side menu
    let onReorder: (IndexSet, Int) -> Void // Callback to reorder positions
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            Text("Clippings Order")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
                .padding(.top, -5)
                .padding(.bottom, 5)
            
            if clippings.isEmpty {
                // Empty state
                VStack {
                    Spacer()
                    Text("No clippings loaded")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                    Text("Load clippings to reorder them")
                        .foregroundColor(.gray)
                        .font(.caption)
                    Spacer()
                }
            } else {
                // Draggable list of clipping icons
                List {
                    ForEach(Array(clippings.enumerated()), id: \.element.id) { index, clipping in
                        CollageSideMenuIconView(clipping: clipping, menuWidth: menuWidth)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                    }
                    .onMove { from, to in
                        // Reorder clippings array and positions
                        clippings.move(fromOffsets: from, toOffset: to)
                        onReorder(from, to)
                    }
                }
                .listStyle(PlainListStyle())
                .background(Color.clear)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

// Preview
struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        let mockClippings = createMockClippings()
        let menuWidth = UIScreen.main.bounds.width * 0.45
        
        SideMenuView(
            presentSideMenu: .constant(true),
            clippings: .constant(mockClippings),
            menuWidth: menuWidth,
            onReorder: { _, _ in } // Empty closure for preview
        )
        .previewDisplayName("SideMenuView")
    }
    
    static func createMockClippings() -> [Clipping] {
        var clippings: [Clipping] = []
        
        for i in 1...5 {
            let clipping = Clipping()
            clipping.id = "preview_\(i)"
            clipping.name = "Preview Clipping \(i)"
            clipping.width = 10.0
            clipping.height = 12.0
            clipping.imageUrlThumb = "mock_url_thumb_\(i)"
            clipping.imageThumb = UIImage(named: "clippingThumb_\(i)")
            clipping.isHead = true
            clipping.isBody = false
            clippings.append(clipping)
        }
        
        return clippings
    }
} 
