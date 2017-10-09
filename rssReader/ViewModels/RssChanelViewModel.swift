//
//  RssChanelViewModel.swift
//  rssReader
//
//  Created by Brody Bela on 27/09/2017.
//  Copyright © 2017 Brody Media. All rights reserved.
//

import Foundation
import RxSwift

class RssChanelViewModel {
    let chanel: RssChanel
    let isSelected = Variable<Bool>(false)

    init(chanel: RssChanel) {
        self.chanel = chanel
    }
}
