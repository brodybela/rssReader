//
//  RssDataService.swift
//  rssReader
//
//  Created by Brody Bela on 27/09/2017.
//  Copyright © 2017 Brody Media. All rights reserved.
//

import Foundation
import FeedKit
import CleanroomLogger
import UIKit

class RssDataService: DataService {
    func getFeed(chanel data: RssChanel, onCompletion: @escaping ([RssItem]) -> Void) {
        guard let feedURL = URL(string: data.rss), let parser = FeedParser(URL: feedURL) else {
            onCompletion([])
            return
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Log.debug?.message("Loading \(feedURL)")
        
        parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { result in
            if let rss = result.rssFeed, let items = rss.items {
                onCompletion(items.map({ RssItem(title: $0.title, description: $0.description, link: $0.link, pubDate: $0.pubDate) }))
            } else {
                onCompletion([])
            }
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
}
