//
//  ResponseAlbums.swift
//  Test Enaza
//
//  Created by Andrew Krotov on 16/04/2019.
//  Copyright © 2019 Andrew Krotov. All rights reserved.
//

public struct ResponseAlbums: Codable {
    var albums: [String]
    
    public enum CodingKeys: String, CodingKey {
        case albums
    }
}
