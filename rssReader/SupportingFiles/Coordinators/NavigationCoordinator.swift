//
//  NavigationCoordinator.swift
//  rssReader
//
//  Created by Brody Bela on 27/09/2017.
//  Copyright © 2017 Brody Media. All rights reserved.
//

import Foundation
import UIKit
import Swinject

protocol NavigationCoordinator: Coordinator {
    var navigationController: UINavigationController { get }
    var container: Container { get }
}
