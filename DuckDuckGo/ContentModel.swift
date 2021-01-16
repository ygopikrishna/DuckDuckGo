//
//  ContentModel.swift
//  DuckDuckGo
//
//  Created by Gopi Krishna on 11/19/19.
//  Copyright © 2019 iCreditWorks. All rights reserved.
//

import Foundation

struct ContentData: Codable {
    let RelatedTopics: [ContentObject]
    let Heading: String
}

struct ContentObject: Codable {
    let FirstURL: String
    let Text: String
    let Icon : IconData
    let Result: String
}

struct IconData: Codable {
    let URL: String
}
