//
//  Post.swift
//  InstaSave
//
//  Created by Vladyslav Yakovlev on 3/1/19.
//  Copyright © 2019 Vladyslav Yakovlev. All rights reserved.
//

import UIKit

final class Post {
    
    let user: User
    
    let imageUrl: URL
    
    let videoUrl: URL?
    
    var image: UIImage?
    
    var isVideo: Bool {
        return videoUrl != nil
    }

    init(user: User, imageUrl: URL, videoUrl: URL?) {
        self.user = user
        self.imageUrl = imageUrl
        self.videoUrl = videoUrl
    }
}
