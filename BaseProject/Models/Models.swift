//
//  Models.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 3/30/23.
//

import Foundation
import SwiftUI

// MARK: -- Shape Model

class Shape: Identifiable, ObservableObject, Codable, Hashable {
    var id: String = UUID().uuidString
    var name: String
    var imageName: String
    var type: String
    var color: Color
    var colorName: String
    
    // Empty initializer for flexibility (previews, Core Data, etc.)
    init() {
        self.name = ""
        self.imageName = ""
        self.type = ""
        self.color = .gray
        self.colorName = "gray"
    }
    
    // Main initializer
    init(name: String, imageName: String, color: Color) {
        self.name = name
        self.imageName = imageName
        self.type = imageName.components(separatedBy: ".").first ?? imageName
        self.color = color
        self.colorName = color.description
    }
    
    // Codable conformance
    enum CodingKeys: String, CodingKey {
        case id, name, imageName, type, colorName
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        imageName = try container.decode(String.self, forKey: .imageName)
        type = try container.decode(String.self, forKey: .type)
        colorName = try container.decode(String.self, forKey: .colorName)
        // Convert colorName back to Color
        color = Color(colorName)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(imageName, forKey: .imageName)
        try container.encode(type, forKey: .type)
        try container.encode(colorName, forKey: .colorName)
    }
    
    // Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Shape, rhs: Shape) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: -- Shape Data

extension Shape {
    static let sampleShapes: [Shape] = [
        Shape(name: "Red Circle", imageName: "circle.red", color: .red),
        Shape(name: "Green Rectangle", imageName: "rectangle.green", color: .green),
        Shape(name: "Blue Square", imageName: "square.blue", color: .blue),
        Shape(name: "Yellow Triangle", imageName: "triangle.yellow", color: .yellow),
        Shape(name: "Yellow Star", imageName: "star.yellow", color: .yellow),
        Shape(name: "Green Arrow", imageName: "arrow.green", color: .green),
        Shape(name: "Red Heart", imageName: "heart.red", color: .red),
        Shape(name: "Blue Triangle", imageName: "triangle.blue", color: .blue),
        Shape(name: "Purple Oval", imageName: "oval.purple", color: .purple)
    ]
}
