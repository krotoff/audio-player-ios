//
//  AudioService.swift
//  Test Enaza
//
//  Created by Andrew Krotov on 17/04/2019.
//  Copyright © 2019 Andrew Krotov. All rights reserved.
//

import AVFoundation

public protocol AudioServiceDelegate {
    func switchPlayStatus(to isPlaying: Bool)
    func updateTimeProccess(to value: Float)
    func selectedTrack(_ track: ComposedTrackInfo?)
}

public class AudioService: NSObject {
    public static let sharedInstance = AudioService()
    
    private var delegate: AudioServiceDelegate?
    private let networking: NetworkingGateway = .sharedInstance
    private let trackService: TrackService = .sharedInstance
    
    private var selectedIndex: Int?
    private var player: AVAudioPlayer?
    private var timer: Timer?
    
    private override init() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers, .allowAirPlay])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }
    
    public func setDelegate(_ delegate: AudioServiceDelegate) {
        self.delegate = delegate
    }
    
    public func isPlaying() -> Bool {
        return player?.isPlaying ?? false
    }
    
    public func setTrack(with index: Int?) {
        guard let index = index else {
            assertionFailure("### ERR #AudioService #setTrack: no index")
            return
        }
        
        if selectedIndex != index {
            selectedIndex = index
            
            guard let path = Bundle.main.path(forResource: "\(index % 16).mp3", ofType: nil) else {
                assertionFailure("### ERR #AudioService #setTrack: incorrect path")
                return
            }
            let url = URL(fileURLWithPath: path)
            
            do {
                player = try AVAudioPlayer(contentsOf: url)
            } catch {
                assertionFailure(error.localizedDescription)
            }
            
            player?.delegate = self
            
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimeProccess), userInfo: nil, repeats: true)
            
            switchPlay()
        }
    }
    
    public func switchPlay() {
        if isPlaying() {
            player?.pause()
        } else {
            player?.play()
        }
        delegate?.switchPlayStatus(to: isPlaying())
    }
    
    public func setTimeProccess(to value: Float) {
        guard let player = player else {
            delegate?.updateTimeProccess(to: 0)
            return
        }
        
        player.currentTime = TimeInterval(value) * player.duration / 100
    }
    
    @objc private func updateTimeProccess() {
        guard let player = player else {
            delegate?.updateTimeProccess(to: 0)
            return
        }
        
        delegate?.updateTimeProccess(to: Float(100 * player.currentTime / player.duration))
    }
}

extension AudioService: AVAudioPlayerDelegate {
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        delegate?.switchPlayStatus(to: false)
        
        let newIndex = ((selectedIndex ?? 0) + 1) % 16
        setTrack(with: newIndex)
        trackService.selectTrack(newIndex)
        
        delegate?.selectedTrack(trackService.getSelectedTrack())
    }
}
