//
//  PlayerView.swift
//  Test Enaza
//
//  Created by Andrew Krotov on 17/04/2019.
//  Copyright © 2019 Andrew Krotov. All rights reserved.
//

import UIKit

public class PlayerView: UIView {
    private let mainStackView = UIStackView()
    private let secondaryStackView = UIStackView()
    
    private let thumbnailView = UIImageView()
    private let trackNameLabel = UILabel()
    private let artistAndAlbumLabel = UILabel()
    public let timeScroll = UISlider()
    public let playButton = UIButton()
    
    public override func layoutSubviews() {
        backgroundColor = .white
        
        mainStackView.distribution = .fill
        mainStackView.alignment = .fill
        
        secondaryStackView.axis = .vertical
        secondaryStackView.distribution = .fillEqually
        
        layout()
    }
    
    private func layout() {
        self.addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(thumbnailView)
        mainStackView.addArrangedSubview(secondaryStackView)
        
        secondaryStackView.addArrangedSubview(trackNameLabel)
        secondaryStackView.addArrangedSubview(artistAndAlbumLabel)
        secondaryStackView.addArrangedSubview(playButton)
        secondaryStackView.addArrangedSubview(timeScroll)
        
        setOrientation(isLandscape: UIDevice.current.orientation.isLandscape)
        
        mainStackView.fillInContainer()
        
        thumbnailView.squareAspect()
        
        trackNameLabel.contentMode = .center
        trackNameLabel.textAlignment = .center
        
        artistAndAlbumLabel.contentMode = .center
        artistAndAlbumLabel.textAlignment = .center
        
        playButton.contentMode = .center
        
        NSLayoutConstraint.activate([
            timeScroll.leftAnchor.constraint(equalTo: secondaryStackView.leftAnchor, constant: 16),
            timeScroll.rightAnchor.constraint(equalTo: secondaryStackView.rightAnchor, constant: -16)
            ])
        
        timeScroll.setThumbImage(UIImage(), for: .normal)
        timeScroll.minimumValue = 0
        timeScroll.maximumValue = 100
    }
    
    public func fill(with track: ComposedTrackInfo?) {
        guard let track = track else {
            assertionFailure("### ERR #PlayerView #fill: no track")
            return
        }
        
        trackNameLabel.text = track.name
        
        artistAndAlbumLabel.text = track.artists.map { $0.name }.joined(separator: ", ") + " - " + track.album.name
        
        thumbnailView.image = UIImage(named: "cdIcon")?.scaled(fit: CGSize(width: 42, height: 42))
        thumbnailView.downloaded(from: track.coverURL)
    }
    
    public func setOrientation(isLandscape: Bool) {
        mainStackView.axis = isLandscape ? .horizontal : .vertical
    }
    
    public func setPlayingStatus(to isPlaying: Bool) {
        let imageName = isPlaying ?  "pauseIcon" : "playIcon"
        playButton.setImage(UIImage(named: imageName)?.scaled(fit: CGSize(width: 24, height: 24)), for: .normal)
    }
    
    public func updateTimeSlider(to value: Float) {
        timeScroll.value = value
    }
}
