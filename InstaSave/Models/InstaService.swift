//
//  InstaService.swift
//  InstaSave
//
//  Created by Vladyslav Yakovlev on 3/1/19.
//  Copyright © 2019 Vladyslav Yakovlev. All rights reserved.
//

import UIKit

final class InstaService {
    
    static func checkLink(_ link: String) -> String? {
        let regex = try! NSRegularExpression(pattern: "^https://(www.)?instagram.com/.*/", options: .caseInsensitive)
        let matches = regex.matches(in: link, options: [], range: NSMakeRange(0, link.count))
        guard !matches.isEmpty else {
            return nil
        }
        if let activeLink = link.components(separatedBy: "?").first {
            return activeLink
        } else {
            return nil
        }
    }
    
    static func getMediaPost(with link: String, completion: @escaping (Post?) -> ()) {
        getJson(link) { json in
            guard let json = json else {
                return DispatchQueue.main.async {
                    completion(nil)
                }
            }
            parseJson(json) { post in
                DispatchQueue.main.async {
                    completion(post)
                }
            }
        }
    }
    
    private static func getJson(_ link: String, completion: @escaping (Json?) -> ()) {
        let url = URL(string: "\(link)?__a=1")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                return completion(nil)
            }
            if let json = (try? JSONSerialization.jsonObject(with: data)) as? Json {
                completion(json)
            } else {
                completion(nil)
            }
        }.resume()
    }
    
    private static func parseJson(_ json: Json, completion: @escaping (Post?) -> ()) {
        guard let graph = json["graphql"] as? Json,
            let media = graph["shortcode_media"] as? Json,
            let owner = media["owner"] as? Json else {
                return completion(nil)
        }
        
        guard let username = owner["username"] as? String,
            let avatarUrl = (owner["profile_pic_url"] as? String)?.url else {
                return completion(nil)
        }
        
        let user = User(username: username, avatarUrl: avatarUrl)
        
        URLSession.getImage(url: avatarUrl) { avatarImage in
            user.avatarImage = avatarImage
            
            guard let imageUrl = (media["display_url"] as? String)?.url else {
                return completion(nil)
            }
            
            URLSession.getImage(url: imageUrl) { image in
                guard let image = image else {
                    return completion(nil)
                }
                
                let videoUrl = (media["video_url"] as? String)?.url
                
                let post = Post(user: user, imageUrl: imageUrl, videoUrl: videoUrl)
                post.image = image
                
                completion(post)
            }
        }
    }
}

