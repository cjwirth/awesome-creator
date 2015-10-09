//
//  output.swift
//  awesome-creator
//
//  Created by Caesar Wirth on 4/13/15.
//  Copyright (c) 2015 Caesar Wirth. All rights reserved.
//

import Foundation

func readFile(filename: String) -> String {
    let string = (try? NSString(contentsOfFile: filename, encoding: NSUTF8StringEncoding)) as? String
    return string ?? ""
}

func licenses() -> String { return readFile("./LICENSES.md") }
func template() -> String { return readFile("./TEMPLATE.md") }

func writeToFile(file: String, string: String) {
    let fm = NSFileManager.defaultManager()
    if !fm.fileExistsAtPath("./output") {
        do {
            try fm.createDirectoryAtPath("./output", withIntermediateDirectories: true, attributes: nil)
        } catch _ {
        }
    }
    if !fm.fileExistsAtPath("./output/pages") {
        do {
            try fm.createDirectoryAtPath("./output/pages", withIntermediateDirectories: true, attributes: nil)
        } catch _ {
        }
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
    
    let pageData = pages.map(pageOutput).lazy
    let ps = pageData.joinWithSeparator("\n")
    
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
        writeToFile("/pages/"+page.filename, string: pageString)
    }
}

func writeTemplate(bag: [String: String]) {
    let temp = template()
    let substituted = bagSubstitution(temp, bag: bag)
    
    writeToFile("README.md", string: substituted)
}

func bagSubstitution(template: String, bag: [String: String]) -> String {
    let lines = template.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
    
    let substitutedLines = lines.map { (line: String) -> String in
        if line.hasPrefix("[[") && line.hasSuffix("]]") {
            let key = line.stringByReplacingOccurrencesOfString("[[", withString: "").stringByReplacingOccurrencesOfString("]]", withString: "")
            if let value = bag[key] {
                return value
            }
        }
        return line
    }
    
    return substitutedLines.joinWithSeparator("\n")
}

func links(pages: [Page]) -> String {
    let links = pages.map { (page: Page) -> String in
        let anchor = page.name.lowercaseString.stringByReplacingOccurrencesOfString(" ", withString: "-").stringByReplacingOccurrencesOfString("/", withString: "")
        return "* [\(page.name)](#\(anchor)) - [file](/pages/\(page.filename))"
    }
    
    return links.joinWithSeparator("\n")
}

func pageOutput(page: Page) -> String {
    var string = "\(page.name)\n"
    for _ in 0..<page.name.characters.count {
        string += "="
    }
    string += "\nRepo | Demo\n"
    string += "--- | ---\n"
    
    let repoTags = page.repos.map(repoOutput)
    let repos = repoTags.joinWithSeparator("\n")
    
    string += repos
    string += "\n\n"
    return string
}

func repoOutput(repo: Repo) -> String {
    var string = "[\(repo.name)](\(repo.url)) <br> \(starImgUrl(repo)) <br> Language: \(repo.language) <br> License: [\(repo.license)][\(repo.license)] | "
    
    let imageTags = repo.images.map(imageTag)
    let images = imageTags.joinWithSeparator(" ")
    
    string += images
    
    return string
}

func starImgUrl(repo: Repo) -> String {
    return "[![](http://gh-btns.cjwirth.com/stars/\(repo.author)/\(repo.name))](https://github.com/\(repo.author)/\(repo.name)/stargazers)"
}

func imageTag(image: Image) -> String {
    var imgUrl = "<img src=\"/assets/\(image.name)\""
    if image.size.characters.count > 0 {
        imgUrl += " width=\"\(image.size)\" "
    }
    imgUrl += ">"
    return imgUrl
}
