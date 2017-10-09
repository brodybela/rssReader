//
//  UINavigationController+Extensions.swift
//  rssReader
//
//  Created by Brody Bela on 27/09/2017.
//  Copyright © 2017 Brody Media. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    func setBackButton() {
        let backButton = UIBarButtonItem()
        backButton.title = "back".localized
        viewControllers.last?.navigationItem.backBarButtonItem = backButton
    }
}
