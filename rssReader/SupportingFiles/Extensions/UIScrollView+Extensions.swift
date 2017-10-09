//
//  UIScrollView+Extensions.swift
//  rssReader
//
//  Created by Brody Bela on 27/09/2017.
//  Copyright © 2017 Brody Media. All rights reserved.
//

import Foundation
import UIKit

extension UIScrollView {
    func setBottomInset(height: CGFloat) {
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: height, right: 0)
        contentInset = contentInsets
        scrollIndicatorInsets = contentInsets
    }
}
