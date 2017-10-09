//
//  RssFeedViewModel.swift
//  rssReader
//
//  Created by Brody Bela on 27/09/2017.
//  Copyright © 2017 Brody Media. All rights reserved.
//

import Foundation
import RxSwift
import CleanroomLogger
import UIKit

class RssFeedViewModel {

    // MARK: - Properties

    let feed: Observable<[RssItem]>
    let load = PublishSubject<Void>() // signal that starts feed loading
    let title: String

    init(rssDataService: DataService, settingsService: SettingsService) {
        guard let chanel = settingsService.selectedChanel else {
            Log.error?.message("Chanel not selected, nothing to show in feed")
            fatalError("Chanel not selected, nothing to show in feed")
        }

        let loadFeed: Observable<[RssItem]> = Observable.create { observer in
            rssDataService.getFeed(chanel: chanel) { items in
                observer.onNext(items)
                observer.onCompleted()
            }

            return Disposables.create {
            }
        }
        feed = load.startWith(()).flatMapLatest { _ in return loadFeed }.share()
        title = chanel.title
    }
}
