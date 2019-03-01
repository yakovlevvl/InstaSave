//
//  MuteButton.swift
//  InstaSave
//
//  Created by Vladyslav Yakovlev on 3/1/19.
//  Copyright © 2019 Vladyslav Yakovlev. All rights reserved.
//

import UIKit

enum MuteButtonState {
    
    case mute
    case unmute
}

final class MuteButton: UIButton {
    
    var controlState: MuteButtonState = .unmute {
        didSet {
            setImage(controlState == .unmute ? unmuteImage : muteImage, for: .normal)
        }
    }
    
    var muteImage = UIImage(named: "MuteIcon") {
        didSet {
            if controlState == .mute {
                controlState = .mute
            }
        }
    }
    
    var unmuteImage = UIImage(named: "UnmuteIcon") {
        didSet {
            if controlState == .unmute {
                controlState = .unmute
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentMode = .center
        setImage(unmuteImage, for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


