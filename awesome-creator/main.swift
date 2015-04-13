//
//  main.swift
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
    var url = ""
    var license = ""

    var images: [Image] = []

    init() { }

    func update(json: [String: AnyObject]) {
        name = json["name"] as? String ?? ""
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

func dataFilePaths() -> [String] {
    var paths: [String] = []
    let fileManager = NSFileManager.defaultManager()

    if let datas = fileManager.contentsOfDirectoryAtPath("data", error: nil) {
        for data in datas {
            if let file = data as? String {
                paths.append("./data/" + file)
            }
        }
    }

    return paths
}

func readDataFile(path: String) -> Page {
    let page = Page()
    var error: NSError?
    if let
        data = NSData(contentsOfFile: path),
    json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: &error) as? [String: AnyObject]
    {
        page.update(json)
    }

    if let error = error {
        println(error)
    }
    return page
}

let paths = dataFilePaths()
let pages = paths.map(readDataFile)
//println(readDataFile(paths[0]))
println("Hello World")


