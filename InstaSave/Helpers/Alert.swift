//
//  Alert.swift
//  InstaSave
//
//  Created by Vladyslav Yakovlev on 3/1/19.
//  Copyright © 2019 Vladyslav Yakovlev. All rights reserved.
//

import VYAlertController

final class Alert {
    
    static func showMessage(_ message: String) {
        let alertVC = VYAlertController(message: message, style: .alert)
        alertVC.messageFont = UIFont(name: Fonts.circeBold, size: 21)!
        alertVC.actionTitleFont = UIFont(name: Fonts.circeBold, size: 21)!
        let okayAction = VYAlertAction(title: "Okay", style: .cancel)
        alertVC.addAction(okayAction)
        alertVC.present()
    }
}
