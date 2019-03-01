//
//  User.swift
//  InstaSave
//
//  Created by Vladyslav Yakovlev on 3/1/19.
//  Copyright © 2019 Vladyslav Yakovlev. All rights reserved.
//

import UIKit

final class User {
    
    let username: String
    
    let avatarUrl: URL
    
    var avatarImage: UIImage?
    
    init(username: String, avatarUrl: URL) {
        self.username = username
        self.avatarUrl = avatarUrl
    }
}
