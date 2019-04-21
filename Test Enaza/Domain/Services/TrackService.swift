//
//  TrackService.swift
//  Test Enaza
//
//  Created by Andrew Krotov on 16/04/2019.
//  Copyright © 2019 Andrew Krotov. All rights reserved.
//

import Foundation
import UIKit

public protocol TrackServiceDelegate {
    func gotAlbum(_ result: Result<Bool, NetworkingError<ResponseError>>)
}

public class TrackService {
    public static let sharedInstance = TrackService()
    
    private let albumIds = [
        394903, 380604, 389061, 364079, 386135, 361668, 382799, 364206, 382726, 382946, 378269, 382487, 379705, 383073, 380349, 386116,
        379701, 379704, 377092, 379748
    ]
    private var currentData: TrackListResponse?
    private var currentTrack: ComposedTrackInfo?
    private var tracks: [Track]?
    private var albumThumbnail: UIImage?
    
    private var delegate: TrackServiceDelegate?
    private let networking: NetworkingGateway = .sharedInstance
    
    private init() {
        networking.setDelegate(self)
    }
    
    public func getTracks() -> [Track] {
        guard let tracks = tracks else { return [] }
        
        return tracks
    }
    
    public func selectTrack(_ index: Int) {
        guard
            let data = currentData,
            let collection = data.collection,
            let tracks = tracks,
            tracks.count > index,
            let album = collection.album.values.first
        else {
            assertionFailure("### ERR #TrackService #selectTrack: incorrectData")
            return
        }
        
        currentTrack = ComposedTrackInfo(track: tracks[index], album: album, people: collection.people, index: index)
    }
    
    public func getSelectedTrack() -> ComposedTrackInfo? {
        return currentTrack
    }
    
    public func getThumbnail() -> UIImage? {
        return albumThumbnail
    }
    
    public func setDelegate(_ delegate: TrackServiceDelegate) {
        self.delegate = delegate
    }
    
    public func requestAlbum() {
//        networking.requestAlbum(id: albumIds[Int(arc4random_uniform(UInt32(albumIds.count)))])
        networking.requestAlbum(id: 364079)
    }
}

extension TrackService: NetworkingGatewayDelegate {
    public func gotCover(_ result: Result<Data, NetworkingError<ResponseError>>) {
        switch result {
        case let .success(data):
            guard
                let image = UIImage(data: data)
            else {
                albumThumbnail = nil
                return
            }
            
            albumThumbnail = image
        case .failure(_):
            albumThumbnail = nil
        }
        
        DispatchQueue.main.async() { [delegate, tracks] in
            delegate?.gotAlbum(result.map { _ in !(tracks?.isEmpty ?? true) })
        }
        
    }
    
    public func gotAlbum(_ result: Result<TrackListResponse, NetworkingError<ResponseError>>) {
        switch result {
        case let .success(data):
            currentData = data
            if let collection = data.collection {
                tracks = Array(collection.track.values).sorted(by: { $0.name < $1.name })
                if let first = collection.track.values.first {
                    networking.getCover(from: first.cover)
                }
            } else {
                clearAlbumInfo()
            }
        case .failure(_):
            currentData = nil
            clearAlbumInfo()
        }
        
        DispatchQueue.main.async() { [delegate, tracks] in
            delegate?.gotAlbum(result.map { _ in !(tracks?.isEmpty ?? true) })
        }
    }
    
    private func clearAlbumInfo() {
        tracks = nil
        albumThumbnail = nil
    }
}
