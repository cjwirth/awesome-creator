//
//  models.swift
//  awesome-creator
//
//  Created by Caesar Wirth on 4/13/15.
//  Copyright (c) 2015 Caesar Wirth. All rights reserved.
//

import Foundation

class Image {
    var name = ""
    var size = ""
    
    init() { }
    
    func update(json: [String: AnyObject]) {
        name = json["name"] as? String ?? ""
        size = json["size"] as? String ?? ""
    }
}

class Repo {
    var name = ""
    var author = ""
    var url = ""
    var language = ""
    var license = ""
    
    var images: [Image] = []
    
    init() { }
    
    func update(json: [String: AnyObject]) {
        name = json["name"] as? String ?? ""
        author = json["author"] as? String ?? ""
        language = json["language"] as? String ?? ""
        url = json["url"] as? String ?? ""
        license = json["license"] as? String ?? ""
        
        if let imgData = json["images"] as? [[String: AnyObject]] {
            for data in imgData {
                let image = Image()
                image.update(data)
                images.append(image)
            }
        }
    }
}

class Page {
    var name = ""
    var filename = ""
    var repos: [Repo] = []
    
    init() {}
    
    func update(json: [String: AnyObject]) {
        name = json["name"] as? String ?? ""
        
        if let repoData = json["repos"] as? [[String: AnyObject]] {
            for data in repoData {
                let repo = Repo()
                repo.update(data)
                repos.append(repo)
            }
        }
    }
}