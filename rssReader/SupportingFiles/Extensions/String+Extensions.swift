//
//  String+Extensions.swift
//  rssReader
//
//  Created by Brody Bela on 27/09/2017.
//  Copyright © 2017 Brody Media. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }

    var isValidURL: Bool {
        return isStringLink(string: self)
    }

    private func isStringLink(string: String) -> Bool {
        let types: NSTextCheckingResult.CheckingType = [.link]
        let detector = try? NSDataDetector(types: types.rawValue)
        guard detector != nil && string.characters.count > 0 else { return false }
        if detector!.numberOfMatches(in: string, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, string.characters.count)) > 0 {
            return true
        }
        return false
    }
}
