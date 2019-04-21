//
//  PlayerController.swift
//  Test Enaza
//
//  Created by Andrew Krotov on 16/04/2019.
//  Copyright © 2019 Andrew Krotov. All rights reserved.
//

import UIKit

class PlayerController: UIViewController {
    private let trackService: TrackService = .sharedInstance
    private let audioService: AudioService = .sharedInstance
    
    private lazy var rootView = PlayerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = rootView
        
        audioService.setDelegate(self)
        
        rootView.fill(with: trackService.getSelectedTrack())
        rootView.setPlayingStatus(to: audioService.isPlaying())
        
        rootView.playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        rootView.timeScroll.addTarget(self, action: #selector(setTimeProccess(with:)), for: .valueChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        audioService.setTrack(with: trackService.getSelectedTrack()?.indexInAlbum)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        rootView.setOrientation(isLandscape: UIDevice.current.orientation.isLandscape)
    }
    
    @objc func playButtonTapped() {
        audioService.switchPlay()
    }
    
    @objc func setTimeProccess(with slider: UISlider) {
        audioService.setTimeProccess(to: slider.value)
    }
}

extension PlayerController: AudioServiceDelegate {
    func switchPlayStatus(to isPlaying: Bool) {
        rootView.setPlayingStatus(to: isPlaying)
    }
    
    func updateTimeProccess(to value: Float) {
        rootView.updateTimeSlider(to: value)
    }
    
    func selectedTrack(_ track: ComposedTrackInfo?) {
        rootView.fill(with: track)
    }
}
