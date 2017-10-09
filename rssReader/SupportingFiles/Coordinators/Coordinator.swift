//
//  Coordinator.swift
//  rssReader
//
//  Created by Brody Bela on 27/09/2017.
//  Copyright © 2017 Brody Media. All rights reserved.
//

import Foundation
import Swinject

protocol Coordinator: class {
    var container: Container { get }
    func start()
}
