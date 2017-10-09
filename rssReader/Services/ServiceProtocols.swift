//
//  ServiceProtocols.swift
//  rssReader
//
//  Created by Brody Bela on 27/09/2017.
//  Copyright © 2017 Brody Media. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol DataService: class {
    func getFeed(chanel: RssChanel, onCompletion: @escaping ([RssItem]) -> Void)
}

protocol SettingsService: class {
    var selectedChanel: RssChanel? { get set }
}
