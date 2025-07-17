//
//  CollageSideMenuIconView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 6/27/25.
//

import SwiftUI

// Simple square icon view for clippings in the side menu
struct CollageSideMenuIconView: View {
    let clipping: Clipping
    let menuWidth: CGFloat // Width of the side menu
    let iconSizeRatio: CGFloat = 0.9 // size as percentage of menu width (40%) - larger since single column
    var iconSize: CGFloat {
        return menuWidth * iconSizeRatio
    }
    
    var body: some View {
        AsyncImage1(clipping: clipping,
                    placeholder: clipping.imageThumb ?? UIImage())
            .frame(width: iconSize, height: iconSize)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(.systemGray4), lineWidth: 1)
            )
    }
}

// Preview
struct CollageSideMenuIconView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            // iPhone size preview
            let iPhoneMenuWidth = UIScreen.main.bounds.width * 0.45
            // Show vertical list for single column layout
            VStack(spacing: 15) {
                CollageSideMenuIconView(clipping: createMockClipping(1), menuWidth: iPhoneMenuWidth)
                CollageSideMenuIconView(clipping: createMockClipping(2), menuWidth: iPhoneMenuWidth)
                CollageSideMenuIconView(clipping: createMockClipping(3), menuWidth: iPhoneMenuWidth)
                CollageSideMenuIconView(clipping: createMockClipping(4), menuWidth: iPhoneMenuWidth)
                CollageSideMenuIconView(clipping: createMockClipping(5), menuWidth: iPhoneMenuWidth)
            }
            
            // iPad size preview
            let iPadMenuWidth = 768.0 * 0.45 // Assuming iPad width is 768 points
            VStack(spacing: 15) {
                CollageSideMenuIconView(clipping: createMockClipping(1), menuWidth: iPadMenuWidth)
                CollageSideMenuIconView(clipping: createMockClipping(2), menuWidth: iPadMenuWidth)
                CollageSideMenuIconView(clipping: createMockClipping(3), menuWidth: iPadMenuWidth)
            }
        }
        .padding()
        .previewDisplayName("CollageSideMenuIconView")
    }
    
    static func createMockClipping(_ number: Int = 1) -> Clipping {
        let clipping = Clipping()
        clipping.id = "preview"
        clipping.name = "Preview Clipping"
        clipping.width = 10.0
        clipping.height = 12.0
        clipping.imageUrlThumb = "mock_url_thumb"
        clipping.imageThumb = UIImage(named: "clippingThumb_\(number)")
        clipping.isHead = true
        clipping.isBody = false
        return clipping
    }
} 
