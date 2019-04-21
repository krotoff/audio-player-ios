//
//  Album.swift
//  Test Enaza
//
//  Created by Andrew Krotov on 16/04/2019.
//  Copyright © 2019 Andrew Krotov. All rights reserved.
//

public struct AlbumResponseInfo: Codable {
    var productId: String
    var categoryIds: [String]
    var productChildIds: [Int]
    
    public enum CodingKeys: String, CodingKey {
        case productId
        case categoryIds
        case productChildIds
    }
}

public struct AlbumResponseCollection: Codable {
    var album: [String: Album]
    var category: [String: Category]
    var track: [String: Track]
    var people: [String: Artist]
    
    public enum CodingKeys: String, CodingKey {
        case album
        case category
        case track
        case people
    }
}

public struct Album: Codable {
    var id: String
    var name: String
    var peopleIds: [String]
    
    public enum CodingKeys: String, CodingKey {
        case id
        case name
        case peopleIds
    }
}
