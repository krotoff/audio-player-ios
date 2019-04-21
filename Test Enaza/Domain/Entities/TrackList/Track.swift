//
//  Track.swift
//  Test Enaza
//
//  Created by Andrew Krotov on 17/04/2019.
//  Copyright © 2019 Andrew Krotov. All rights reserved.
//

public struct Track: Codable {
    var id: String
    var name: String
    var cover: String
    var peopleIds: [String]
    
    public enum CodingKeys: String, CodingKey {
        case id
        case name
        case cover
        case peopleIds
    }
}

public struct ComposedTrackInfo {
    var id: String
    var name: String
    var album: Album
    var artists: [Artist]
    var coverURL: String
    var indexInAlbum: Int
    
    init(track: Track, album: Album, people: [String: Artist], index: Int) {
        self.id = track.id
        self.name = track.name
        self.album = album
        self.coverURL = track.cover
        self.indexInAlbum = index
        
        self.artists = []
        track.peopleIds.forEach({
            if let artist = people[$0] {
                artists.append(artist)
            }
        })
    }
}
