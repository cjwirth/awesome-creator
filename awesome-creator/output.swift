//
//  output.swift
//  awesome-creator
//
//  Created by Caesar Wirth on 4/13/15.
//  Copyright (c) 2015 Caesar Wirth. All rights reserved.
//

import Foundation

func readFile(filename: String) -> String {
    let string = NSString(contentsOfFile: filename, encoding: NSUTF8StringEncoding, error: nil) as? String
    return string ?? ""
}

func licenses() -> String { return readFile("./LICENSES.md") }
func template() -> String { return readFile("./TEMPLATE.md") }

func writeToFile(file: String, string: String) {
    let fm = NSFileManager.defaultManager()
    if !fm.fileExistsAtPath("./output") {
        fm.createDirectoryAtPath("./output", withIntermediateDirectories: true, attributes: nil, error: nil)
    }
    if !fm.fileExistsAtPath("./output/pages") {
        fm.createDirectoryAtPath("./output/pages", withIntermediateDirectories: true, attributes: nil, error: nil)
    }
    
    let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
    if let finished = data?.writeToFile("./output/"+file, atomically: true) {
        if !finished {
            NSLog("Failed to write to file: \(file)")
        }
    }
}

func write(pages: [Page]) {
    writePages(pages)
    
    let pageData = lazy( pages.map(pageOutput) )
    let ps = join("\n", pageData)
    
    var templateBag: [String: String] = [:]
    templateBag["LINKS"] = links(pages)
    templateBag["CONTENT"] = ps
    templateBag["LICENSES"] = licenses()
    

    writeTemplate(templateBag)
}

func writePages(pages: [Page]) {
    let licenseLinks = licenses()
    
    
    
    for page in pages {
        var pageString = pageOutput(page)
        pageString += licenseLinks
        writeToFile("/pages/"+page.filename, pageString)
    }
}

func writeTemplate(bag: [String: String]) {
    let temp = template()
    let substituted = bagSubstitution(temp, bag)
    
    writeToFile("README.md", substituted)
}

func bagSubstitution(template: String, bag: [String: String]) -> String {
    let lines = template.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
    
    let substitutedLines = map(lines) { (line: String) -> String in
        if line.hasPrefix("[[") && line.hasSuffix("]]") {
            let key = line.stringByReplacingOccurrencesOfString("[[", withString: "").stringByReplacingOccurrencesOfString("]]", withString: "")
            if let value = bag[key] {
                return value
            }
        }
        return line
    }
    
    return join("\n", substitutedLines)
}

func links(pages: [Page]) -> String {
    let links = map(pages) { (page: Page) -> String in
        let anchor = page.name.lowercaseString.stringByReplacingOccurrencesOfString(" ", withString: "-").stringByReplacingOccurrencesOfString("/", withString: "")
        return "* [\(page.name)](#\(anchor)) - [file](/pages/\(page.filename))"
    }
    
    return join("\n", links)
}

func pageOutput(page: Page) -> String {
    var string = "\(page.name)\n"
    for i in 0..<count(page.name) {
        string += "="
    }
    string += "\nRepo | Demo\n"
    string += "--- | ---\n"
    
    let repoTags = page.repos.map(repoOutput)
    let repos = join("\n", repoTags)
    
    string += repos
    string += "\n\n"
    return string
}

func repoOutput(repo: Repo) -> String {
    var string = "[\(repo.name)](\(repo.url)) <br> \(starImgUrl(repo)) <br> Language: \(repo.language) <br> License: [\(repo.license)][\(repo.license)] | "
    
    let imageTags = repo.images.map(imageTag)
    let images = join(" ", imageTags)
    
    string += images
    
    return string
}

func starImgUrl(repo: Repo) -> String {
    return "[![](http://gh-btns.cjwirth.com/stars/\(repo.author)/\(repo.name))](https://github.com/\(repo.author)/\(repo.name)/stargazers)"
}

func imageTag(image: Image) -> String {
    var imgUrl = "<img src=\"/assets/\(image.name)\""
    if count(image.size) > 0 {
        imgUrl += " width=\"\(image.size)\" "
    }
    imgUrl += ">"
    return imgUrl
}
