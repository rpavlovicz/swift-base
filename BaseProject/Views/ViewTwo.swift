//
//  ViewTwo.swift
//  BaseProject
//
//  Created by Ryan Pavlovicz on 6/17/25.
//

import SwiftUI

enum ColorFilter: CaseIterable {
    case all, red, green, blue, yellow, purple
    
    var color: Color? {
        switch self {
        case .all: return nil
        case .red: return .red
        case .green: return .green
        case .blue: return .blue
        case .yellow: return .yellow
        case .purple: return .purple
        }
    }
    
    var displayName: String {
        switch self {
        case .all: return "All"
        case .red: return "Red"
        case .green: return "Green"
        case .blue: return "Blue"
        case .yellow: return "Yellow"
        case .purple: return "Purple"
        }
    }
}

struct ViewTwo: View {
    @EnvironmentObject var sourceModel: SourceModel
    @EnvironmentObject var navigationStateManager: NavigationStateManager
    @State private var searchText = ""
    @State private var selectedColorFilter: ColorFilter = .all
    @State private var showingAddShape = false
    @State private var selectedImage = "circle.red"
    
    private var filteredShapes: [Shape] {
        var shapes = sourceModel.shapes
        
        // Filter by search text
        if !searchText.isEmpty {
            shapes = shapes.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        
        // Filter by color
        if let filterColor = selectedColorFilter.color {
            shapes = shapes.filter { $0.color == filterColor }
        }
        
        return shapes
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Search and Filter Bar
            VStack(spacing: 12) {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search shapes...", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                // Color Filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(ColorFilter.allCases, id: \.self) { filter in
                            ColorFilterButton(filter: filter, isSelected: selectedColorFilter == filter) {
                                selectedColorFilter = filter
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            
            // Results
            if filteredShapes.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    
                    Text("No shapes found")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    Text("Try adjusting your search or filters")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(filteredShapes) { shape in
                    ShapeRow(shape: shape)
                }
            }
        }
        .navigationTitle("View Two")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Add") {
                    showingAddShape = true
                }
            }
        }
        .sheet(isPresented: $showingAddShape) {
            AddShapeView()
        }
    }
}

// MARK: - Color Filter Button
struct ColorFilterButton: View {
    let filter: ColorFilter
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if filter == .all {
                    Image(systemName: "circle.grid.2x2")
                        .font(.caption)
                } else {
                    Circle()
                        .fill(filter.color ?? .black)
                        .frame(width: 12, height: 12)
                }
                
                Text(filter == .all ? "All" : filter.displayName)
                    .font(.caption)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(isSelected ? Color.blue : Color.clear)
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.blue : Color.gray, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Shape Row
struct ShapeRow: View {
    let shape: Shape
    
    var body: some View {
        HStack(spacing: 16) {
            // Shape Image
            Image(shape.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .foregroundColor(shape.color)
            
            // Shape Info
            VStack(alignment: .leading, spacing: 4) {
                Text(shape.name)
                    .font(.headline)
                
                HStack {
                    Circle()
                        .fill(shape.color)
                        .frame(width: 12, height: 12)
                    Text(shape.colorName)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // Action Button
            Button("Details") {
                // Template: Add detail view navigation
                print("Show details for \(shape.name)")
            }
            .buttonStyle(.bordered)
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Add Shape View
struct AddShapeView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var sourceModel: SourceModel
    @State private var shapeName = ""
    @State private var selectedColor: Color = .red
    @State private var selectedImage = "circle.red"
    
    private let availableImages = ["circle.red", "rectangle.green", "square.blue", "triangle.yellow", "star.yellow", "arrow.green", "heart.red", "triangle.blue", "oval.purple"]
    private let availableColors: [Color] = [.red, .green, .blue, .yellow, .purple]
    
    var body: some View {
        NavigationView {
            Form {
                Section("Shape Details") {
                    TextField("Shape Name", text: $shapeName)
                    
                    Picker("Color", selection: $selectedColor) {
                        ForEach(availableColors, id: \.self) { color in
                            HStack {
                                Circle()
                                    .fill(color)
                                    .frame(width: 20, height: 20)
                                Text(colorName(for: color))
                            }
                            .tag(color)
                        }
                    }
                    
                    Picker("Image", selection: $selectedImage) {
                        ForEach(availableImages, id: \.self) { imageName in
                            HStack {
                                Image(imageName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20, height: 20)
                                Text(imageName.capitalized)
                            }
                            .tag(imageName)
                        }
                    }
                }
                
                Section("Preview") {
                    HStack {
                        Image(selectedImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 60)
                            .foregroundColor(selectedColor)
                        
                        VStack(alignment: .leading) {
                            Text(shapeName.isEmpty ? "New Shape" : shapeName)
                                .font(.headline)
                            Text("\(imageName.capitalized) • \(colorName(for: selectedColor))")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Add Shape")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        let newShape = Shape(
                            name: shapeName.isEmpty ? "New Shape" : shapeName,
                            imageName: selectedImage,
                            color: selectedColor
                        )
                        sourceModel.addShape(newShape)
                        dismiss()
                    }
                    .disabled(shapeName.isEmpty)
                }
            }
        }
    }
    
    private func colorName(for color: Color) -> String {
        switch color {
        case .red: return "Red"
        case .green: return "Green"
        case .blue: return "Blue"
        case .yellow: return "Yellow"
        case .purple: return "Purple"
        default: return "Unknown"
        }
    }
    
    private var imageName: String {
        selectedImage.capitalized
    }
}

// MARK: - Preview
struct ViewTwo_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ViewTwo()
                .environmentObject(SourceModel())
                .environmentObject(NavigationStateManager())
        }
    }
}

