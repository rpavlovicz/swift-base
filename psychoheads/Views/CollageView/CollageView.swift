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
    @State private var geometrySize: CGSize = .zero
    
    // Side Menu State
    @State private var presentSideMenu = false
    @State private var clippingOrder: [String] = [] // Track clipping order by ID
    
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
                    loadRandomClippings()
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
        UIScreen.main.bounds.height - 40 // Space for button row
    }
    
    // Calculate the center point for clippings (center of available space above button row)
    private var clippingCenterY: CGFloat {
        (UIScreen.main.bounds.height - 40) / 2
    }
    
    // Load random clippings and position them
    private func loadRandomClippings() {
        let randomClippings = Array(sourceModel.headClippings.shuffled().prefix(2))
        clippings = randomClippings
        
        // Calculate sizes to determine which is larger
        let clippingSizes = randomClippings.map { calculateImageSize(for: $0) }
        let areas = clippingSizes.map { $0.width * $0.height }
        
        // Find the larger and smaller clipping indices
        let largerIndex = areas[0] > areas[1] ? 0 : 1
        let smallerIndex = largerIndex == 0 ? 1 : 0
        
        // Check if clippings are within 85% size match
        let largerArea = areas[largerIndex]
        let smallerArea = areas[smallerIndex]
        let sizeRatio = smallerArea / largerArea
        let isSimilarSize = sizeRatio >= 0.85
        
        // Use actual geometry dimensions for accurate positioning
        let centerX = geometrySize.width / 2
        let centerY = geometrySize.height / 2
        
        // Position larger clipping in center
        var newPositions = Array(repeating: CGPoint.zero, count: randomClippings.count)
        newPositions[largerIndex] = CGPoint(x: centerX, y: centerY)
        
        // Position smaller clipping offset based on larger clipping's dimensions and looking direction
        let largerClippingSize = clippingSizes[largerIndex]
        let largerClipping = randomClippings[largerIndex]
        
        // Determine horizontal offset based on looking direction
        let horizontalMultiplier: CGFloat
        if let lookingDirection = largerClipping.lookingDirection {
            switch lookingDirection {
            case "upperRight", "right", "lowerRight":
                horizontalMultiplier = -0.3 // Shift left
            case "up", "fullFace", "down":
                // For up/down/fullFace, check the smaller clipping's direction
                let smallerClipping = randomClippings[smallerIndex]
                if let smallerLookingDirection = smallerClipping.lookingDirection {
                    switch smallerLookingDirection {
                    case "upperLeft", "left", "lowerLeft":
                        horizontalMultiplier = -0.3 // Shift left for left-facing smaller clipping
                    default:
                        horizontalMultiplier = 0.3 // Shift right for all other cases
                    }
                } else {
                    horizontalMultiplier = 0.3 // Default to right if smaller clipping has no direction
                }
            default:
                horizontalMultiplier = 0.3 // Shift right
            }
        } else {
            horizontalMultiplier = 0.3 // Default to right if no looking direction
        }
        
        // Apply size-based multiplier adjustment
        let finalHorizontalMultiplier = isSimilarSize ? horizontalMultiplier * (0.5 / 0.3) : horizontalMultiplier
        let finalVerticalMultiplier: CGFloat = isSimilarSize ? 0.5 : 0.3
        
        let offsetX = centerX + (largerClippingSize.width * finalHorizontalMultiplier)
        let offsetY = centerY + (largerClippingSize.height * finalVerticalMultiplier)
        newPositions[smallerIndex] = CGPoint(x: offsetX, y: offsetY)
        
        positions = newPositions
        dragOffsets = randomClippings.map { _ in .zero }
        invertZOrder = false
    }
    
    // Reorder positions when clippings are reordered
    private func reorderPositions(from: IndexSet, to: Int) {
        positions.move(fromOffsets: from, toOffset: to)
        dragOffsets = clippings.map { _ in .zero }
    }
    
    // Add another random head clipping
    private func addRandomHead() {
        let availableHeads = sourceModel.headClippings.filter { head in
            !clippings.contains { $0.id == head.id }
        }
        
        guard let randomHead = availableHeads.randomElement() else {
            // No more unique heads available
            return
        }
        
        clippings.append(randomHead)
        
        // Calculate position for the new clipping
        let imageSize = calculateImageSize(for: randomHead)
        let centerX = geometrySize.width / 2
        let centerY = geometrySize.height / 2
        
        // Position the new clipping with some random offset
        let randomOffsetX = CGFloat.random(in: -50...50)
        let randomOffsetY = CGFloat.random(in: -50...50)
        let newPosition = CGPoint(x: centerX + randomOffsetX, y: centerY + randomOffsetY)
        
        positions.append(newPosition)
        dragOffsets.append(.zero)
    }
    
    // Calculate proper image size based on clipping dimensions and available space (match ClippingsSwipeView)
    private func calculateImageSize(for clipping: Clipping) -> CGSize {
        let maxWidthFraction: CGFloat = 0.65
        let maxHeightFraction: CGFloat = 0.6
        let screenWidth = UIScreen.main.bounds.width * maxWidthFraction
        let screenHeight = UIScreen.main.bounds.height * maxHeightFraction
        let cmToPoints: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 52.85 : 60.8
        let clippingWidthPoints = CGFloat(clipping.width) * cmToPoints
        let clippingHeightPoints = CGFloat(clipping.height) * cmToPoints
        let widthScale = screenWidth / clippingWidthPoints
        let heightScale = screenHeight / clippingHeightPoints
        let scale = min(widthScale, heightScale, 1.0)
        return CGSize(
            width: clippingWidthPoints * scale,
            height: clippingHeightPoints * scale
        )
    }
    
    // Calculate the scale indicator text (match ClippingsSwipeView)
    private func scaleIndicatorText(for clipping: Clipping, imageSize: CGSize) -> String {
        let cmToPoints: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 52.85 : 60.8
        let originalWidthPoints = CGFloat(clipping.width) * cmToPoints
        let originalHeightPoints = CGFloat(clipping.height) * cmToPoints
        let widthScale = imageSize.width / originalWidthPoints
        let heightScale = imageSize.height / originalHeightPoints
        let scale = min(widthScale, heightScale, 1.0)
        if scale >= 0.99 {
            return "1x"
        } else {
            return String(format: "%.2fx", scale)
        }
    }
    
    // Calculate area of a clipping
    private func calculateArea(for clipping: Clipping) -> CGFloat {
        let size = calculateImageSize(for: clipping)
        return size.width * size.height
    }
    
    // Get z-index order based on array order (side menu controls this)
    private func zIndexOrder() -> [Int] {
        if invertZOrder {
            return Array(clippings.indices).reversed()
        } else {
            return Array(clippings.indices)
        }
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                GeometryReader { geometry in
                    ZStack(alignment: .bottomTrailing) {
                        // Center guide lines
                        VStack {
                            // Vertical center line
                            Rectangle()
                                .fill(Color.red.opacity(0.5))
                                .frame(width: 1)
                                .frame(maxHeight: .infinity)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        
                        HStack {
                            // Horizontal center line
                            Rectangle()
                                .fill(Color.blue.opacity(0.5))
                                .frame(height: 1)
                                .frame(maxWidth: .infinity)
                        }
                        .frame(maxHeight: .infinity, alignment: .center)
                        
                        if !clippings.isEmpty {
                            ForEach(Array(clippings.enumerated()), id: \.element.id) { index, clipping in
                                let imageSize = calculateImageSize(for: clipping)
                                AsyncImage2(clipping: clipping,
                                            placeholder: UIImage(),
                                            imageUrlMid: clipping.imageUrlMid,
                                            frameHeight: imageSize.height)
                                    .frame(width: imageSize.width,
                                           height: imageSize.height)
                                    .position(x: positions[index].x + dragOffsets[index].width,
                                             y: positions[index].y + dragOffsets[index].height)
                                    .zIndex(Double(zIndexOrder().firstIndex(of: index) ?? 0))
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
                        
                        // Scaling indicator overlay (positioned like in ClippingsSwipeView)
                        if !clippings.isEmpty {
                            let largestClipping = clippings.max(by: { calculateImageSize(for: $0).width * calculateImageSize(for: $0).height < calculateImageSize(for: $1).width * calculateImageSize(for: $1).height })!
                            let imageSize = calculateImageSize(for: largestClipping)
                            HStack(spacing: 4) {
                                Image(systemName: "square.resize.down")
                                    .font(.caption)
                                Text(scaleIndicatorText(for: largestClipping, imageSize: imageSize))
                                    .font(.caption)
                                    .fontWeight(.medium)
                            }
                            .padding(6)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color(.systemBackground).opacity(0.9))
                                    .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
                            )
                            .padding(.trailing, 10)
                            .padding(.bottom, 27)
                        }
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .onAppear {
                        geometrySize = geometry.size
                    }
                    .onChange(of: geometry.size) { newSize in
                        geometrySize = newSize
                    }
                }
                CollageButtonRow(
                    onLoad: loadRandomClippings,
                    onAddHead: addRandomHead,
                    onMenu: {
                        withAnimation { presentSideMenu.toggle() }
                    }
                )
                .frame(maxHeight: 40)
            }
            // Side Menu overlay
            SideMenu(isShowing: $presentSideMenu, content: AnyView(
                SideMenuView(
                    presentSideMenu: $presentSideMenu,
                    clippings: $clippings,
                    menuWidth: UIScreen.main.bounds.width * 0.45,
                    onReorder: reorderPositions
                )
            ))
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if !presentSideMenu {
                    Button(action: { withAnimation { presentSideMenu.toggle() } }) {
                        Image(systemName: "line.3.horizontal")
                            .imageScale(.large)
                    }
                }
            }
        }
    }
}


// Simple Side Menu Container with swipe-to-close and swipe-reveal
struct SideMenu: View {
    let isShowing: Binding<Bool>
    let content: AnyView
    
    @State private var dragOffset: CGFloat = 0.0
    let menuWidth = UIScreen.main.bounds.width * 0.45
    let closeThreshold: CGFloat = 60
    
    var body: some View {
        ZStack {
            if isShowing.wrappedValue {
                Rectangle()
                    .fill(Color.black.opacity(0.3))
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.interactiveSpring()) {
                            isShowing.wrappedValue = false
                        }
                    }
                HStack {
                    Spacer()
                    content
                        .frame(width: menuWidth)
                        .background(Color(.systemBackground))
                        .offset(x: dragOffset)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    // Only allow dragging right (positive x)
                                    if value.translation.width > 0 {
                                        dragOffset = value.translation.width
                                    }
                                }
                                .onEnded { value in
                                    if value.translation.width > closeThreshold {
                                        withAnimation(.interactiveSpring()) {
                                            isShowing.wrappedValue = false
                                        }
                                        dragOffset = 0
                                    } else {
                                        withAnimation(.interactiveSpring()) {
                                            dragOffset = 0
                                        }
                                    }
                                }
                        )
                        .transition(.move(edge: .trailing))
                        .animation(.interactiveSpring(), value: dragOffset)
                }
            }
        }
        .animation(.easeInOut, value: isShowing.wrappedValue)
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
        
        return NavigationView {
            CollageView()
                .environmentObject(mockSourceModel)
                .navigationTitle("Collage")
        }
        .previewDevice("iPhone 14 Pro")
        .previewDisplayName("CollageView - iPhone 14 Pro")
    }
}
