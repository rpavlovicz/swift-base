import Foundation
import SwiftUI
// Uncomment when ready to use Firebase
// import FirebaseFirestore

class SourceModel: ObservableObject {
    @Published var shapes: [Shape] = []
    @Published var lastModified: Date = Date()
    
    // Firebase setup - uncomment when ready to use Firebase
    // private let db = Firestore.firestore()
    
    init() {
        // Initialize with sample data
        shapes = Shape.sampleShapes
    }
    
    // MARK: - Firebase Operations
    // These operations are commented out but ready to use when Firebase is integrated
    // To use Firebase:
    // 1. Add Firebase to your project using Swift Package Manager
    // 2. Initialize Firebase in your App delegate
    // 3. Uncomment the Firebase import and db property above
    // 4. Uncomment the operations below
    
    /*
    func saveShape(_ shape: Shape) async throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(shape)
        let dictionary = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        
        try await db.collection("shapes").document(shape.id).setData(dictionary!)
    }
    
    func loadShape(id: String) async throws -> Shape {
        let document = try await db.collection("shapes").document(id).getDocument()
        guard let data = document.data() else {
            throw NSError(domain: "FirebaseError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document not found"])
        }
        
        let jsonData = try JSONSerialization.data(withJSONObject: data)
        return try JSONDecoder().decode(Shape.self, from: jsonData)
    }
    
    func loadAllShapes() async throws {
        let snapshot = try await db.collection("shapes").getDocuments()
        shapes = try snapshot.documents.compactMap { document in
            let data = try JSONSerialization.data(withJSONObject: document.data())
            return try JSONDecoder().decode(Shape.self, from: data)
        }
    }
    
    func deleteShape(_ shape: Shape) async throws {
        try await db.collection("shapes").document(shape.id).delete()
        if let index = shapes.firstIndex(where: { $0.id == shape.id }) {
            shapes.remove(at: index)
        }
    }
    */
    
    // MARK: - Local Operations
    // These operations work with the local shapes array
    // They can be used to test the app without Firebase
    
    func addShape(_ shape: Shape) {
        shapes.append(shape)
        updateLastModified()
    }
    
    func removeShape(_ shape: Shape) {
        shapes.removeAll { $0.id == shape.id }
        updateLastModified()
    }
    
    func updateShape(_ shape: Shape) {
        if let index = shapes.firstIndex(where: { $0.id == shape.id }) {
            shapes[index] = shape
            updateLastModified()
        }
    }
    
    // MARK: - Sample Data Operations
    // These operations help with testing and development
    
    func resetToSampleData() {
        shapes = Shape.sampleShapes
        updateLastModified()
    }
    
    func addSampleShape() {
        let newShape = Shape(
            name: "New Shape \(shapes.count + 1)",
            imageName: ["circle.red", "rectangle.green", "square.blue", "triangle.yellow", "star.yellow", "arrow.green", "heart.red", "triangle.blue", "oval.purple"].randomElement() ?? "circle.red",
            color: [.red, .green, .blue, .yellow, .purple].randomElement() ?? .gray
        )
        addShape(newShape)
    }
    
    // MARK: - Change Tracking
    // These operations help track changes to the data
    
    private func updateLastModified() {
        lastModified = Date()
    }
    
    func hasChanges(comparedTo other: SourceModel) -> Bool {
        return shapes != other.shapes
    }
    
    // MARK: - Data Management
    // These operations help manage the data
    
    func clone() -> SourceModel {
        let copy = SourceModel()
        copy.shapes = shapes
        copy.lastModified = lastModified
        return copy
    }
    
    func update(from other: SourceModel) {
        shapes = other.shapes
        lastModified = other.lastModified
    }
    
    // MARK: - Image Management
    // These operations help manage images when needed
    // Uncomment and modify when adding image support
    
    /*
    func loadImage(for shape: Shape) async throws -> UIImage? {
        // Example implementation for loading images
        // Replace with your image loading logic
        return nil
    }
    
    func saveImage(_ image: UIImage, for shape: Shape) async throws {
        // Example implementation for saving images
        // Replace with your image saving logic
    }
    */
} 