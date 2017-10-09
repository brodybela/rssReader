//
//  RssChanel.swift
//  rssReader
//
//  Created by Brody Bela on 27/09/2017.
//  Copyright © 2017 Brody Media. All rights reserved.
//

import Foundation

struct RssChanel: Codable {
    let title: String
    let url: String
    let rss: String
    let logo: String?
}

extension RssChanel: Equatable {
    static func ==(lhs: RssChanel, rhs: RssChanel) -> Bool {
        return lhs.rss == rhs.rss
    }
}
