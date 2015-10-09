//
//  main.swift
//  awesome-creator
//
//  Created by Caesar Wirth on 4/13/15.
//  Copyright (c) 2015 Caesar Wirth. All rights reserved.
//

import Foundation

enum Error: ErrorType {
    case InvalidJSON
}

func dataFilePaths() -> [String] {
    var paths: [String] = []
    let fileManager = NSFileManager.defaultManager()
    
    if let datas = try? fileManager.contentsOfDirectoryAtPath("data") {
        for file in datas {
            if !file.hasSuffix(".json") {
                continue
            }
            if file == "Template.json" {
                continue
            }
            paths.append("./data/" + file)
        }
    }
    
    return paths
}


func readDataFile(path: String) -> Page {
    let page = Page()
    let pathURL = NSURL(string: path)
    
    do {
        guard let data = NSData(contentsOfFile: path) else {
            return page
        }
        
        guard let jsonObject = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0)),
            json = jsonObject as? [String: AnyObject]
            else {
                throw Error.InvalidJSON
        }
        
        page.update(json)
        page.filename = pathURL?.pathComponents?.last?.stringByReplacingOccurrencesOfString("json", withString: "md") ?? ""
    } catch _ {
        print("NSJSONSerialization error!")
    }
    
    return page
}


let paths = dataFilePaths()
let pages = paths.map(readDataFile)


write(pages)



