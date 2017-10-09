//
//  UserDefaultsService.swift
//  rssReader
//
//  Created by Brody Bela on 27/09/2017.
//  Copyright © 2017 Brody Media. All rights reserved.
//

import Foundation

class UserDefaultsSettingsService: SettingsService {
    var selectedChanel: RssChanel? {
        get {
            let jsonDecoder = JSONDecoder()
            if let serialized = UserDefaults.standard.data(forKey: "source"), let data = try? jsonDecoder.decode(RssChanel.self, from: serialized) {
                return data
            }
            return nil
        }
        set {
            let jsonEncoder = JSONEncoder()
            let serialized = try! jsonEncoder.encode(newValue)
            UserDefaults.standard.set(serialized, forKey: "source")
        }
    }
}
