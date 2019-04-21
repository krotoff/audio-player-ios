//
//  Responses.swift
//  Test Enaza
//
//  Created by Andrew Krotov on 16/04/2019.
//  Copyright © 2019 Andrew Krotov. All rights reserved.
//

public struct AlbumListResponse: Codable {
    var error: ResponseError
    var response: ResponseAlbums
    var collection: TrackCollection
    
    public enum CodingKeys: String, CodingKey {
        case error
        case response
        case collection
    }
}

public struct TrackListResponse: Codable {
    var error: ResponseError?
    var response: AlbumResponseInfo?
    var collection: AlbumResponseCollection?
    
    public enum CodingKeys: String, CodingKey {
        case error
        case response
        case collection
    }
}
