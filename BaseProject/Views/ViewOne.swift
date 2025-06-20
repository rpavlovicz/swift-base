//
//  ViewOne.swift
//  BaseProject
//
//  Created by Template on 2024.
//

import SwiftUI

struct ViewOne: View {
    @EnvironmentObject var sourceModel: SourceModel
    @EnvironmentObject var navigationStateManager: NavigationStateManager
    @State private var selectedShape: Shape?
    @State private var showingShapeDetail = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 8) {
                Text("View One")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Shape Gallery")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.top)
            
            // Shape Grid
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.adaptive(minimum: 150, maximum: 200))
                ], spacing: 16) {
                    ForEach(sourceModel.shapes) { shape in
                        ShapeCard(shape: shape) {
                            selectedShape = shape
                            showingShapeDetail = true
                        }
                    }
                }
                .padding()
            }
            
            // Action Buttons
            HStack(spacing: 20) {
                Button("Add Shape") {
                    sourceModel.addSampleShape()
                }
                .buttonStyle(.borderedProminent)
                
                Button("Reset") {
                    sourceModel.resetToSampleData()
                }
                .buttonStyle(.bordered)
            }
            .padding(.bottom)
        }
        .navigationTitle("View One")
        .sheet(isPresented: $showingShapeDetail) {
            if let shape = selectedShape {
                ShapeDetailView(shape: shape)
            }
        }
    }
}

// MARK: - Shape Card
struct ShapeCard: View {
    let shape: Shape
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                Image(shape.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .foregroundColor(shape.color)
                
                Text(shape.name)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .shadow(radius: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Shape Detail View
struct ShapeDetailView: View {
    let shape: Shape
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // Shape Image
                Image(shape.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .foregroundColor(shape.color)
                
                // Shape Info
                VStack(spacing: 16) {
                    Text(shape.name)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    HStack {
                        Circle()
                            .fill(shape.color)
                            .frame(width: 20, height: 20)
                        Text("Color: \(shape.colorName)")
                            .font(.subheadline)
                    }
                    
                    Text("ID: \(shape.id)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Shape Detail")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Preview
struct ViewOne_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ViewOne()
                .environmentObject(SourceModel())
                .environmentObject(NavigationStateManager())
        }
    }
}

