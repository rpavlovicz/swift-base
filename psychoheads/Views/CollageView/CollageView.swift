//
//  CollageView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 6/27/25.
//


//
//  CollageView.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 6/7/25.
//

import SwiftUI
import FirebaseFirestore
// Import CollageButtonRow from its own file

struct CollageView: View {
    
    @EnvironmentObject var sourceModel: SourceModel
    @State private var clippings: [Clipping] = []
    @State private var positions: [CGPoint] = []
    @State private var dragOffsets: [CGSize] = []
    @State private var invertZOrder = false
    
    struct CollageButton: Identifiable {
        let id = UUID()
        let label: String
        let systemImage: String?
        let action: () -> Void
        let isEnabled: Bool
    }
    
    var collageButtons: [CollageButton] {
        [
            CollageButton(
                label: Constants.clown,
                systemImage: nil,
                action: {
                    let randomClippings = Array(sourceModel.headClippings.shuffled().prefix(2))
                    clippings = randomClippings
                    positions = randomClippings.map { _ in CGPoint(x: UIScreen.main.bounds.width/2, y: displayHeight/2) }
                    dragOffsets = randomClippings.map { _ in .zero }
                    invertZOrder = false
                },
                isEnabled: true
            ),
            CollageButton(
                label: "",
                systemImage: "arrow.up.arrow.down",
                action: {
                    withAnimation { invertZOrder.toggle() }
                },
                isEnabled: !clippings.isEmpty
            )
        ]
    }
    
    // Calculate available display space
    private var displayWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
    private var displayHeight: CGFloat {
        UIScreen.main.bounds.height - 120 // Increased space for two buttons
    }
    
    // Calculate maximum allowed image dimensions (90% of display space)
    private var maxImageWidth: CGFloat {
        displayWidth * 0.9
    }
    
    private var maxImageHeight: CGFloat {
        displayHeight * 0.9
    }
    
    // Convert centimeters to points (1 cm ≈ 61.07 points based on real-world measurement)
    private func cmToPoints(_ cm: Double) -> CGFloat {
        return CGFloat(cm * 61.07)
    }
    
    // Calculate the maximum dimensions across all clippings
    private func calculateMaxDimensions() -> (width: CGFloat, height: CGFloat) {
        var maxWidth: CGFloat = 0
        var maxHeight: CGFloat = 0
        
        for clipping in clippings {
            let width = cmToPoints(clipping.width)
            let height = cmToPoints(clipping.height)
            maxWidth = max(maxWidth, width)
            maxHeight = max(maxHeight, height)
        }
        
        return (maxWidth, maxHeight)
    }
    
    // Calculate scaling factor based on maximum dimensions
    private func calculateScalingFactor() -> CGFloat {
        let maxDims = calculateMaxDimensions()
        let widthScale = maxDims.width > maxImageWidth ? maxImageWidth / maxDims.width : 1.0
        let heightScale = maxDims.height > maxImageHeight ? maxImageHeight / maxDims.height : 1.0
        
        return min(widthScale, heightScale)
    }
    
    // Calculate scaled image dimensions while maintaining aspect ratio
    private func calculateImageSize(for clipping: Clipping) -> CGSize {
        let originalWidth = cmToPoints(clipping.width)
        let originalHeight = cmToPoints(clipping.height)
        let scale = calculateScalingFactor()
        
        return CGSize(width: originalWidth * scale, height: originalHeight * scale)
    }
    
    // Calculate area of a clipping
    private func calculateArea(for clipping: Clipping) -> CGFloat {
        let size = calculateImageSize(for: clipping)
        return size.width * size.height
    }
    
    // Get sorted indices by area
    private func sortedIndices() -> [Int] {
        let sorted = clippings.indices.sorted { index1, index2 in
            calculateArea(for: clippings[index1]) > calculateArea(for: clippings[index2])
        }
        return invertZOrder ? sorted.reversed() : sorted
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                if !clippings.isEmpty {
                    ForEach(Array(clippings.enumerated()), id: \.element.id) { index, clipping in
                        AsyncImage2(clipping: clipping,
                                    placeholder: UIImage(),
                                    imageUrlMid: clipping.imageUrlMid,
                                    frameHeight: calculateImageSize(for: clipping).height)
                            .frame(width: calculateImageSize(for: clipping).width,
                                   height: calculateImageSize(for: clipping).height)
                            .position(x: positions[index].x + dragOffsets[index].width,
                                     y: positions[index].y + dragOffsets[index].height)
                            .zIndex(Double(sortedIndices().firstIndex(of: index) ?? 0))
                            .gesture(
                                DragGesture()
                                    .onChanged { gesture in
                                        dragOffsets[index] = gesture.translation
                                    }
                                    .onEnded { gesture in
                                        positions[index].x += dragOffsets[index].width
                                        positions[index].y += dragOffsets[index].height
                                        dragOffsets[index] = .zero
                                    }
                            )
                    }
                } else {
                    Text("No clippings loaded")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            CollageButtonRow(
                onLoad: {
                    let randomClippings = Array(sourceModel.headClippings.shuffled().prefix(2))
                    clippings = randomClippings
                    positions = randomClippings.map { _ in CGPoint(x: UIScreen.main.bounds.width/2, y: displayHeight/2) }
                    dragOffsets = randomClippings.map { _ in .zero }
                    invertZOrder = false
                },
                onInvert: {
                    withAnimation { invertZOrder.toggle() }
                },
                invertEnabled: !clippings.isEmpty
            )
            .frame(maxWidth: .infinity, maxHeight: 40)

        }
        //.edgesIgnoringSafeArea(.bottom)
    }
}

// Add a thoughtful preview for CollageView
struct CollageView_Previews: PreviewProvider {
    static var previews: some View {
        let mockSourceModel = SourceModel()
        // Add a few mock clippings to the source model
        let mockClipping1 = Clipping()
        mockClipping1.id = "1"
        mockClipping1.name = "Mock Head 1"
        mockClipping1.width = 10.0
        mockClipping1.height = 12.0
        mockClipping1.imageUrlMid = "mock_url_1"
        mockClipping1.isHead = true
        mockClipping1.isBody = false
        
        let mockClipping2 = Clipping()
        mockClipping2.id = "2"
        mockClipping2.name = "Mock Head 2"
        mockClipping2.width = 8.0
        mockClipping2.height = 10.0
        mockClipping2.imageUrlMid = "mock_url_2"
        mockClipping2.isHead = true
        mockClipping2.isBody = false
        
        let mockClipping3 = Clipping()
        mockClipping3.id = "3"
        mockClipping3.name = "Mock Head 3"
        mockClipping3.width = 12.0
        mockClipping3.height = 14.0
        mockClipping3.imageUrlMid = "mock_url_3"
        mockClipping3.isHead = true
        mockClipping3.isBody = false
        
        let mockSource = Source(title: "Mock Source", year: "2024", month: "July")
        mockSource.clippings = [mockClipping1, mockClipping2, mockClipping3]
        mockSourceModel.sources = [mockSource]
        
        return CollageView()
            .environmentObject(mockSourceModel)
            .previewDevice("iPhone 14 Pro")
            .previewDisplayName("CollageView - iPhone 14 Pro")
    }
}
