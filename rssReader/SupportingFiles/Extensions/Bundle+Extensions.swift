//
//  Bundle+Extensions.swift
//  rssReader
//
//  Created by Brody Bela on 27/09/2017.
//  Copyright © 2017 Brody Media. All rights reserved.
//

import Foundation

extension Bundle {
    static func loadFile(filename fileName: String) -> Data? {
        let parts = fileName.components(separatedBy: ".")
        if let url = Bundle.main.url(forResource: parts[0], withExtension: parts[1]), let data = try? Data(contentsOf: url) {
            return data
        } else {
            return nil
        }
    }
}
