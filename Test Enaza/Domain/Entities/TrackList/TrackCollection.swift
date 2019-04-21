//
//  TrackCollection.swift
//  Test Enaza
//
//  Created by Andrew Krotov on 16/04/2019.
//  Copyright © 2019 Andrew Krotov. All rights reserved.
//

// for https://api.mobimusic.kz/?method=product.getNews

public struct TrackCollection: Codable {
    var album: [String: Track]
    var people: [String: Artist]
    
    public enum CodingKeys: String, CodingKey {
        case album
        case people
    }
}
