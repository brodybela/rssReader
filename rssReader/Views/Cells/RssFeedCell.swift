//
//  RssFeedCell.swift
//  rssReader
//
//  Created by Brody Bela on 27/09/2017.
//  Copyright © 2017 Brody Media. All rights reserved.
//

import UIKit
import Reusable

class RssFeedCell: UITableViewCell, NibReusable {

    // MARK: - Outlets

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!

    // MARK: - Properties

    var model: RssItem? {
        didSet {
            if let model = model {
                titleLabel.text = model.title
                descriptionLabel.text = model.description?.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            }
        }
    }
}
