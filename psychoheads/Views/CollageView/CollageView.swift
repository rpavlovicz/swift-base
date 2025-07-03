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

struct CollageView: View {
    
    @EnvironmentObject var sourceModel: SourceModel
    @State private var clippings: [Clipping] = []
    @State private var positions: [CGPoint] = []
    @State private var dragOffsets: [CGSize] = []
    @State private var invertZOrder = false
    
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
        ZStack(alignment: .bottom) {
            // Main content area
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
                
                // Debug info
                VStack {
                    ForEach(clippings) { clipping in
                        Text("Original: \(String(format: "%.1f", clipping.width)) x \(String(format: "%.1f", clipping.height)) cm")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            } else {
                Text("No clippings loaded")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            // Button area
            HStack(spacing: 16) {
                
                // Load button
                Spacer()
                
                Button(Constants.clown) {
                    let randomClippings = Array(sourceModel.headClippings.shuffled().prefix(2))
                    clippings = randomClippings
                    // Initialize positions and drag offsets for new clippings
                    positions = randomClippings.map { _ in
                        CGPoint(x: UIScreen.main.bounds.width/2, 
                               y: displayHeight/2)
                    }
                    dragOffsets = randomClippings.map { _ in .zero }
                    invertZOrder = false // Reset z-order when loading new images
                }
                .padding()
                //.frame(maxWidth: .infinity)
                .background(Color(UIColor.systemBackground))
                
                Spacer()
                
                // Invert z-order button
                Button(action: {
                    withAnimation {
                        invertZOrder.toggle()
                    }
                }) {
                    HStack {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                }
                .padding()
                //.frame(maxWidth: .infinity)
                .background(Color(UIColor.systemBackground))
                .disabled(clippings.isEmpty)
                .opacity(clippings.isEmpty ? 0.5 : 1.0)
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, 18)
            .background(Color(UIColor.systemBackground))
            //.shadow(radius: 2)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}
//
//struct CollageView_Previews: PreviewProvider {
//    static var previews: some View {
//        CollageView()
//            .environmentObject(SourceModel())
//    }
//}
