//
//  VideoView.swift
//  InstaSave
//
//  Created by Vladyslav Yakovlev on 3/1/19.
//  Copyright © 2019 Vladyslav Yakovlev. All rights reserved.
//

import UIKit
import AVFoundation

final class VideoView: UIView {
    
    var isLooped = true
    
    var showControls = false {
        didSet {
            showControls ? displayControls() : hideControls()
        }
    }
    
    var tapToPlayPause = false {
        didSet {
            tapToPlayPause ? setupTapRecognizer() : removeTapRecognizer()
        }
    }
    
    private var player: AVPlayer?
    
    private let playerLayer = AVPlayerLayer()
    
    private let muteButton: MuteButton = {
        let button = MuteButton(type: .custom)
        button.tintColor = .white
        return button
    }()
    
    private let playPauseButton: PlayPauseButton = {
        let button = PlayPauseButton(type: .custom)
        button.tintColor = .white
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutViews()
    }
    
    private func setupViews() {
        layer.addSublayer(playerLayer)
        
        addSubview(muteButton)
        addSubview(playPauseButton)
        
        muteButton.controlState = .unmute
        
        showControls ? displayControls() : hideControls()
        
        muteButton.addTarget(self, action: #selector(muteButtonTapped), for: .touchUpInside)
        playPauseButton.addTarget(self, action: #selector(playPauseButtonTapped), for: .touchUpInside)
        
        if tapToPlayPause {
            setupTapRecognizer()
        }
    }
    
    private func layoutViews() {
        playerLayer.frame = bounds
        
        playPauseButton.frame.origin.x = 6
        playPauseButton.frame.size = CGSize(width: 40, height: 40)
        playPauseButton.frame.origin.y = frame.height - playPauseButton.frame.height - 6
        
        muteButton.frame.size = CGSize(width: 40, height: 40)
        muteButton.frame.origin.x = frame.width - muteButton.frame.width - 6
        muteButton.frame.origin.y = frame.height - muteButton.frame.height - 6
    }
    
    func configure(with url: URL) {
        player = AVPlayer(url: url)
        player?.automaticallyWaitsToMinimizeStalling = false
        playPauseButton.controlState = .play
        playerLayer.player = player
        removeObserver()
        setupObserver()
    }
    
    private func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(videoFinished), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
    }
    
    private func removeObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupTapRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognized))
        addGestureRecognizer(tapGesture)
    }
    
    private func removeTapRecognizer() {
        guard let tapGesture = gestureRecognizers?.first else { return }
        removeGestureRecognizer(tapGesture)
    }
    
    func play() {
        player?.play()
        playPauseButton.controlState = .pause
    }
    
    func pause() {
        player?.pause()
        playPauseButton.controlState = .play
    }
    
    func stop() {
        pause()
        player?.seek(to: .zero)
        playPauseButton.controlState = .play
    }
    
    func mute() {
        player?.isMuted = true
        muteButton.controlState = .mute
    }
    
    func unmute() {
        player?.isMuted = false
        muteButton.controlState = .unmute
    }
    
    @objc private func videoFinished() {
        if isLooped {
            stop()
            play()
        }
    }
    
    @objc private func muteButtonTapped() {
        muteButton.controlState == .mute ? unmute() : mute()
    }
    
    @objc private func playPauseButtonTapped() {
        playPauseButton.controlState == .play ? play() : pause()
    }
    
    @objc private func tapGestureRecognized() {
        if tapToPlayPause {
            playPauseButtonTapped()
        }
    }
    
    private func displayControls() {
        muteButton.isHidden = false
        playPauseButton.isHidden = false
    }
    
    private func hideControls() {
        muteButton.isHidden = true
        playPauseButton.isHidden = true
    }
    
    deinit {
        removeObserver()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
