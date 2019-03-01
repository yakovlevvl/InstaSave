//
//  PreviewVC.swift
//  InstaSave
//
//  Created by Vladyslav Yakovlev on 3/1/19.
//  Copyright © 2019 Vladyslav Yakovlev. All rights reserved.
//

import UIKit
import VYAlertController

class ImagePreviewVC: UIViewController {
    
    var post: Post!
    
    private let saveButton: RoundButton = {
        let button = RoundButton(type: .custom)
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel!.font = UIFont(name: Fonts.circeBold, size: 21)
        button.titleLabel!.textAlignment = .center
        button.backgroundColor = .white
        button.setShadowOpacity(0.14)
        button.setShadowColor(.gray)
        button.setShadowRadius(12)
        return button
    }()
    
    private let cancelButton: RoundButton = {
        let button = RoundButton(type: .custom)
        button.setTitle("Close", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel!.font = UIFont(name: Fonts.circeBold, size: 21)
        button.titleLabel!.textAlignment = .center
        button.backgroundColor = .white
        button.setShadowOpacity(0.14)
        button.setShadowColor(.gray)
        button.setShadowRadius(12)
        return button
    }()
    
    fileprivate let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    private let avatarView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = Colors.avatarColor
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.circeBold, size: 20)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layoutViews()
    }
    
    fileprivate func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(imageView)
        view.addSubview(avatarView)
        view.addSubview(usernameLabel)
        view.addSubview(saveButton)
        view.addSubview(cancelButton)
        
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        avatarView.image = post.user.avatarImage
        usernameLabel.text = post.user.username
        imageView.image = post.image
    }
    
    fileprivate func layoutViews() {
        avatarView.frame.origin.x = 22
        avatarView.frame.size = CGSize(width: 46, height: 46)
        avatarView.layer.cornerRadius = avatarView.frame.height/2
        
        switch currentDevice {
        case .iPhoneX : avatarView.frame.origin.y = UIProperties.iPhoneXTopInset + 28
        case .iPhone5 : avatarView.frame.origin.y = 15
        default : avatarView.frame.origin.y = 28
        }
        
        usernameLabel.frame.origin.x = 84
        usernameLabel.frame.size.height = 26
        usernameLabel.center.y = avatarView.center.y
        usernameLabel.frame.size.width = view.frame.width - usernameLabel.frame.minX - 36
        
        let buttonInset: CGFloat
        switch currentDevice {
        case .iPhoneX : buttonInset = 40
        case .iPhone5 : buttonInset = 18
        default : buttonInset = 21
        }
        saveButton.frame.size = CGSize(width: 120, height: 56)
        saveButton.frame.origin.y = view.frame.height - saveButton.frame.height - buttonInset
        saveButton.center.x = 3*view.frame.width/4
        
        cancelButton.frame.size = CGSize(width: 120, height: 56)
        cancelButton.frame.origin.y = saveButton.frame.origin.y
        cancelButton.center.x = view.frame.width/4
        
        imageView.frame = view.bounds
        if currentDevice == .iPhone5 {
            imageView.frame.origin.y -= 8
        }
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc fileprivate func saveButtonTapped() {
        SaveService.saveImage(post.image!) { error in
            if let error = error {
                switch error {
                case .accessDenied : self.showAllowAccessMessage()
                case .unknown : self.showSaveErrorMessage()
                }
            } else {
                self.showSaveCompleteMessage()
            }
        }
    }
}

final class VideoPreviewVC: ImagePreviewVC {
    
    private let videoView: VideoView = {
        let videoView = VideoView()
        videoView.backgroundColor = .clear
        videoView.showControls = false
        videoView.tapToPlayPause = false
        videoView.isLooped = true
        return videoView
    }()
    
    fileprivate override func setupViews() {
        super.setupViews()
        imageView.addSubview(videoView)
        videoView.configure(with: post.videoUrl!)
        videoView.play()
    }
    
    fileprivate override func layoutViews() {
        super.layoutViews()
        videoView.frame = imageView.bounds
    }
    
    fileprivate override func saveButtonTapped() {
        SaveService.saveVideo(post.videoUrl!) { error in
            if let error = error {
                switch error {
                case .accessDenied : self.showAllowAccessMessage()
                case .unknown : self.showSaveErrorMessage()
                }
            } else {
                self.showSaveCompleteMessage()
            }
        }
    }
}

extension ImagePreviewVC {
    
    fileprivate func showSaveErrorMessage() {
        Alert.showMessage("Save Error")
    }
    
    fileprivate func showSaveCompleteMessage() {
        let savedLabel = UILabel()
        savedLabel.text = "Saved"
        savedLabel.font = UIFont(name: Fonts.circeBold, size: 21)
        savedLabel.frame.size = CGSize(width: 120, height: 70)
        savedLabel.backgroundColor = .white
        savedLabel.textAlignment = .center
        savedLabel.center = view.center
        view.addSubview(savedLabel)
        savedLabel.alpha = 0
        savedLabel.clipsToBounds = true
        savedLabel.layer.cornerRadius = savedLabel.frame.height/2
        UIView.animate(withDuration: 0.2, animations: { savedLabel.alpha = 1 }) { _ in
            UIView.animate(withDuration: 0.2, delay: 1.0, options: [], animations: { savedLabel.alpha = 0 }) { _ in
                savedLabel.removeFromSuperview()
            }
        }
    }
    
    fileprivate func showAllowAccessMessage() {
        let alertVC = VYAlertController(message: "Allow Photos access", style: .alert)
        alertVC.messageFont = UIFont(name: Fonts.circeBold, size: 21)!
        alertVC.actionTitleFont = UIFont(name: Fonts.circeBold, size: 21)!
        let allowAction = VYAlertAction(title: "Allow", style: .normal) { _ in
            self.allowAccess()
        }
        alertVC.addAction(allowAction)
        alertVC.present()
    }
    
    private func allowAccess() {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:])
    }
}

