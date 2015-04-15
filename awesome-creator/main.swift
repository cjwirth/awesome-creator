//
//  main.swift
//  awesome-creator
//
//  Created by Caesar Wirth on 4/13/15.
//  Copyright (c) 2015 Caesar Wirth. All rights reserved.
//

import Foundation


func dataFilePaths() -> [String] {
    var paths: [String] = []
    let fileManager = NSFileManager.defaultManager()

    if let datas = fileManager.contentsOfDirectoryAtPath("data", error: nil) {
        for data in datas {
            if let file = data as? String {
                if !file.hasSuffix(".json") {
                    continue
                }
                if file == "Template.json" {
                    continue
                }
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
        page.filename = path.pathComponents.last?.stringByReplacingOccurrencesOfString("json", withString: "md") ?? ""
    }

    if let error = error {
        println(error)
    }
    return page
}


let paths = dataFilePaths()
let pages = paths.map(readDataFile)


write(pages)



