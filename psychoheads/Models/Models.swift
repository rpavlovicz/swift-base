//
//  Models.swift
//  psychoheads
//
//  Created by Ryan Pavlovicz on 3/30/23.
//

import Foundation
import SwiftUI
import CoreData

class Source: Identifiable, ObservableObject, Codable, Hashable {
    
    var id: String = ""
    var title: String = ""
    var type: String = ""
    var year: String = ""
    var month: String?
    var issue: String?
    var day: String?
    @Published var ncopies: Int = 0
    var added: Date = Date()
    var imageUrl: String = ""
    var imageUrlMid: String = ""
    var imageUrlThumb: String = ""
    @Published var clippings: [Clipping] = []
    @Published var imageThumb: UIImage?
    
    // Codable related code
    enum CodingKeys: String, CodingKey {
        case id, title, type, year, month, issue, day, ncopies, added, imageUrl, imageUrlMid, imageUrlThumb, imageThumbData
    }
    
    var dateString: String {
        var dateString = ""
        if let month = month, !month.isEmpty {
            dateString = "\(month) "
        }
        if let day = day, !day.isEmpty {
            dateString += "\(day), "
        }
        dateString += "\(year)"
        return dateString
    }
    
    func hasChanges(comparedTo other: Source) -> Bool {
        return title != other.title ||
        type != other.type ||
        year != other.year ||
        month != other.month ||
        issue != other.issue ||
        day != other.day ||
        ncopies != other.ncopies
    }
    
    func update(from other: Source) {
        title = other.title
        type = other.type
        year = other.year
        month = other.month
        issue = other.issue
        day = other.day
        ncopies = other.ncopies
    }
    
    init() {
        // empty initializer
    }
    
    init(title: String = "", year: String = "", month: String = "", day: String = "") {
        self.title = title
        self.year = year
        self.month = month
        self.day = day
    }
    
    init(copyFrom source: Source) {
        id = source.id
        title = source.title
        type = source.type
        year = source.year
        month = source.month
        issue = source.issue
        day = source.day
        ncopies = source.ncopies
        added = source.added
        clippings = source.clippings
        imageUrl = source.imageUrl
        imageUrlMid = source.imageUrlMid
        imageUrlThumb = source.imageUrlThumb
        imageThumb = source.imageThumb
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        type = try container.decode(String.self, forKey: .type)
        year = try container.decode(String.self, forKey: .year)
        month = try container.decodeIfPresent(String.self, forKey: .month)
        issue = try container.decodeIfPresent(String.self, forKey: .issue)
        day = try container.decodeIfPresent(String.self, forKey: .day)
        ncopies = try container.decode(Int.self, forKey: .ncopies)
        added = try container.decode(Date.self, forKey: .added)
        imageUrl = try container.decode(String.self, forKey: .imageUrl)
        imageUrlMid = try container.decode(String.self, forKey: .imageUrlMid)
        imageUrlThumb = try container.decode(String.self, forKey: .imageUrlThumb)
        
        if let imageData = try container.decodeIfPresent(Data.self, forKey: .imageThumbData) {
            imageThumb = UIImage(data: imageData)
        }
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(type, forKey: .type)
        try container.encode(year, forKey: .year)
        try container.encode(month, forKey: .month)
        try container.encode(issue, forKey: .issue)
        try container.encode(day, forKey: .day)
        try container.encode(ncopies, forKey: .ncopies)
        try container.encode(added, forKey: .added)
        try container.encode(imageUrl, forKey: .imageUrl)
        try container.encode(imageUrlMid, forKey: .imageUrlMid)
        try container.encode(imageUrlThumb, forKey: .imageUrlThumb)
        
        if let image = imageThumb, let imageData = image.pngData() {
            try container.encode(imageData, forKey: .imageThumbData)
        }
    }
    
    static func ==(lhs: Source, rhs: Source) -> Bool {
        return lhs.id == rhs.id &&
            lhs.title == rhs.title &&
            lhs.type == rhs.type &&
            lhs.year == rhs.year &&
            lhs.month == rhs.month &&
            lhs.issue == rhs.issue &&
            lhs.day == rhs.day &&
            lhs.ncopies == rhs.ncopies &&
            lhs.added == rhs.added &&
            lhs.imageUrl == rhs.imageUrl &&
            lhs.imageUrlMid == rhs.imageUrlMid &&
            lhs.imageUrlThumb == rhs.imageUrlThumb &&
            lhs.imageThumb == rhs.imageThumb
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}

// MARK: -- clippings


class Clipping: Identifiable, ObservableObject, Codable, Hashable {
 
    var id: String = ""
    var sourceId: String = ""
    var isHead: Bool = false
    var isBody: Bool = false
    var isAnimal: Bool = false
    var isMan: Bool = false
    var isWoman: Bool = false
    var isTrans: Bool = false
    var isWhite: Bool = false
    var isBlack: Bool = false
    var isLatino: Bool = false
    var isAsian: Bool = false
    var isIndian: Bool = false
    var isNative: Bool = false
    var isBlackAndWhite: Bool = false
    var name: String = ""
    var tags: [String] = []
    var width: Double = 0
    var height: Double = 0
    var headWidth: Double?
    var headHeight: Double?
    var lookingDirection: String?
    var added: Date = Date()
    var imageUrl: String = ""
    var imageUrlMid: String = ""
    var imageUrlThumb: String = ""
    @Published var imageThumb: UIImage?
    @Published var imageMid: UIImage?
    
    var size: Double {
        return width * height
    }
    
    init() {
        // empty initializer
    }
    
    enum CodingKeys: String, CodingKey {
        case id, sourceId, isHead, isBody, isAnimal, isMan, isWoman, isTrans, isWhite, isBlack, isLatino, isAsian, isIndian, isNative, isBlackAndWhite, name, tags, width, height, headWidth, headHeight, lookingDirection, added, imageUrl, imageUrlMid, imageUrlThumb, imageThumbData, imageMidData
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        sourceId = try container.decode(String.self, forKey: .sourceId)
        name = try container.decode(String.self, forKey: .name)
        isHead = try container.decode(Bool.self, forKey: .isHead)
        isBody = try container.decode(Bool.self, forKey: .isBody)
        isAnimal = try container.decode(Bool.self, forKey: .isAnimal)
        isMan = try container.decode(Bool.self, forKey: .isMan)
        isWoman = try container.decode(Bool.self, forKey: .isWoman)
        isTrans = try container.decode(Bool.self, forKey: .isTrans)
        isWhite = try container.decode(Bool.self, forKey: .isWhite)
        isBlack = try container.decode(Bool.self, forKey: .isBlack)
        isLatino = try container.decode(Bool.self, forKey: .isLatino)
        isAsian = try container.decode(Bool.self, forKey: .isAsian)
        isIndian = try container.decode(Bool.self, forKey: .isIndian)
        isNative = try container.decode(Bool.self, forKey: .isNative)
        isBlackAndWhite = try container.decode(Bool.self, forKey: .isBlackAndWhite)
        tags = try container.decode([String].self, forKey: .tags)
        width = try container.decode(Double.self, forKey: .width)
        height = try container.decode(Double.self, forKey: .height)
        headWidth = try container.decodeIfPresent(Double.self, forKey: .headWidth)
        headHeight = try container.decodeIfPresent(Double.self, forKey: .headHeight)
        lookingDirection = try container.decodeIfPresent(String.self, forKey: .lookingDirection)
        added = try container.decode(Date.self, forKey: .added)
        imageUrl = try container.decode(String.self, forKey: .imageUrl)
        imageUrlMid = try container.decode(String.self, forKey: .imageUrlMid)
        imageUrlThumb = try container.decode(String.self, forKey: .imageUrlThumb)
        
        if let imageData = try container.decodeIfPresent(Data.self, forKey: .imageThumbData) {
            imageThumb = UIImage(data: imageData)
        }
        
        if let imageData = try container.decodeIfPresent(Data.self, forKey: .imageMidData) {
            imageMid = UIImage(data: imageData)
        }
    }
    
    func clone() -> Clipping {
        let copy = Clipping()
        copy.id = self.id
        copy.sourceId = self.sourceId
        copy.name = self.name
        copy.tags = self.tags
        copy.width = self.width
        copy.height = self.height
        copy.headWidth = self.headWidth
        copy.headHeight = self.headHeight
        copy.lookingDirection = self.lookingDirection
        copy.isHead = self.isHead
        copy.isBody = self.isBody
        copy.isAnimal = self.isAnimal
        copy.isMan = self.isMan
        copy.isWoman = self.isWoman
        copy.isTrans = self.isTrans
        copy.isWhite = self.isWhite
        copy.isBlack = self.isBlack
        copy.isLatino = self.isLatino
        copy.isAsian = self.isAsian
        copy.isIndian = self.isIndian
        copy.isNative = self.isNative
        copy.isBlackAndWhite = self.isBlackAndWhite
        copy.added = self.added
        copy.imageUrl = self.imageUrl
        copy.imageUrlMid = self.imageUrlMid
        copy.imageUrlThumb = self.imageUrlThumb
        copy.imageThumb = self.imageThumb
        copy.imageMid = self.imageMid
        return copy
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(sourceId, forKey: .sourceId)
        try container.encode(name, forKey: .name)
        try container.encode(isHead, forKey: .isHead)
        try container.encode(isBody, forKey: .isBody)
        try container.encode(isAnimal, forKey: .isAnimal)
        try container.encode(isMan, forKey: .isMan)
        try container.encode(isWoman, forKey: .isWoman)
        try container.encode(isTrans, forKey: .isTrans)
        try container.encode(isWhite, forKey: .isWhite)
        try container.encode(isBlack, forKey: .isBlack)
        try container.encode(isLatino, forKey: .isLatino)
        try container.encode(isAsian, forKey: .isAsian)
        try container.encode(isIndian, forKey: .isIndian)
        try container.encode(isNative, forKey: .isNative)
        try container.encode(isBlackAndWhite, forKey: .isBlackAndWhite)
        try container.encode(tags, forKey: .tags)
        try container.encode(width, forKey: .width)
        try container.encode(height, forKey: .height)
        try container.encode(headWidth, forKey: .headWidth)
        try container.encode(headHeight, forKey: .headHeight)
        try container.encode(lookingDirection, forKey: .lookingDirection)
        try container.encode(added, forKey: .added)
        try container.encode(imageUrl, forKey: .imageUrl)
        try container.encode(imageUrlMid, forKey: .imageUrlMid)
        try container.encode(imageUrlThumb, forKey: .imageUrlThumb)
        
        if let image = imageThumb, let imageData = image.pngData() {
            try container.encode(imageData, forKey: .imageThumbData)
        }
        
        if let image = imageMid, let imageData = image.pngData() {
            try container.encode(imageData, forKey: .imageMidData)
        }
    }
    
    static func ==(lhs: Clipping, rhs: Clipping) -> Bool {
        return lhs.id == rhs.id &&
            lhs.sourceId == rhs.sourceId &&
            lhs.name == rhs.name &&
            lhs.isHead == rhs.isHead &&
            lhs.isBody == rhs.isBody &&
            lhs.isAnimal == rhs.isAnimal &&
            lhs.isMan == rhs.isMan &&
            lhs.isWoman == rhs.isWoman &&
            lhs.isTrans == rhs.isTrans &&
            lhs.isWhite == rhs.isWhite &&
            lhs.isBlack == rhs.isBlack &&
            lhs.isLatino == rhs.isLatino &&
            lhs.isAsian == rhs.isAsian &&
            lhs.isIndian == rhs.isIndian &&
            lhs.isNative == rhs.isNative &&
            lhs.isBlackAndWhite == rhs.isBlackAndWhite &&
            lhs.width == rhs.width &&
            lhs.height == rhs.height &&
            lhs.headWidth == rhs.headWidth &&
            lhs.headHeight == rhs.headHeight &&
            lhs.lookingDirection == rhs.lookingDirection &&
            lhs.added == rhs.added &&
            lhs.imageUrl == rhs.imageUrl &&
            lhs.imageUrlMid == rhs.imageUrlMid &&
            lhs.imageUrlThumb == rhs.imageUrlThumb &&
            lhs.imageThumb == rhs.imageThumb &&
            lhs.imageMid == rhs.imageMid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

}

