//
//  MainVC.swift
//  InstaSave
//
//  Created by Vladyslav Yakovlev on 3/1/19.
//  Copyright © 2019 Vladyslav Yakovlev. All rights reserved.
//

import UIKit

final class MainVC: UIViewController {
    
    private let topLabel: UILabel = {
        let label = UILabel()
        label.text = "InstaSave"
        label.font = UIFont(name: Fonts.billabong, size: 46)
        label.textAlignment = .center
        return label
    }()
    
    private let pasteButton: RoundButton = {
        let button = RoundButton(type: .custom)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Paste Link", for: .normal)
        button.titleLabel!.font = UIFont(name: Fonts.circeBold, size: 22)
        button.titleLabel!.textAlignment = .center
        button.backgroundColor = .white
        button.setShadowOpacity(0.14)
        button.setShadowColor(.gray)
        button.setShadowRadius(12)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layoutViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(topLabel)
        view.addSubview(pasteButton)
        
        pasteButton.addTarget(self, action: #selector(pasteButtonTapped), for: .touchUpInside)
    }
    
    private func layoutViews() {
        topLabel.frame.size = CGSize(width: 180, height: 50)
        topLabel.frame.origin.y = currentDevice == .iPhoneX ? UIProperties.iPhoneXTopInset + 84 : 84
        topLabel.center.x = view.center.x
        
        pasteButton.frame.size = CGSize(width: 180, height: 70)
        pasteButton.frame.origin.y = view.frame.height - pasteButton.frame.height - 70
        pasteButton.center.x = view.center.x
    }
    
    @objc private func pasteButtonTapped() {
        if let link = UIPasteboard.general.string {
            checkLink(link)
        } else {
            Alert.showMessage("Copy the post link first")
        }
    }
    
    private func checkLink(_ link: String) {
        guard let activeLink = InstaService.checkLink(link) else {
            showInvalidLinkMessage()
            return
        }
        
        changeButtonTitle()
        InstaService.getMediaPost(with: activeLink) { post in
            self.setInitialButtonTitle()
            guard let post = post else {
                self.showConnectionErrorMessage()
                return
            }
            
            self.showMediaPost(post)
        }
    }
    
    private func showMediaPost(_ post: Post) {
        let previewVC = post.isVideo ? VideoPreviewVC() : ImagePreviewVC()
        previewVC.post = post
        present(previewVC, animated: true)
    }
    
    private func changeButtonTitle() {
        pasteButton.setTitle("Process...", for: .normal)
        pasteButton.isUserInteractionEnabled = false
    }
    
    private func setInitialButtonTitle() {
        pasteButton.setTitle("Paste Link", for: .normal)
        pasteButton.isUserInteractionEnabled = true
    }
    
    private func showConnectionErrorMessage() {
        Alert.showMessage("Connection Error")
    }
    
    private func showInvalidLinkMessage() {
        Alert.showMessage("Invalid Link")
    }
}
