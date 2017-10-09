//
//  StoryboardLodable.swift
//  rssReader
//
//  Created by Brody Bela on 27/09/2017.
//  Copyright © 2017 Brody Media. All rights reserved.
//

import Foundation
import UIKit

protocol StoryboardLodable: class {
    @nonobjc static var storyboardName: String { get }
}

protocol SetupStoryboardLodable: StoryboardLodable {
}

protocol FeedStoryboardLodable: StoryboardLodable {
}

extension SetupStoryboardLodable where Self: UIViewController {
    @nonobjc static var storyboardName: String {
        return "RssChanel"
    }
}

extension FeedStoryboardLodable where Self: UIViewController {
    @nonobjc static var storyboardName: String {
        return "RssFeed"
    }
}
