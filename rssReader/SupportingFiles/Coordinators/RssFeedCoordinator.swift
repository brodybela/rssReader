//
//  RssFeedCoordinator.swift
//  rssReader
//
//  Created by Brody Bela on 27/09/2017.
//  Copyright © 2017 Brody Media. All rights reserved.
//

import Foundation
import UIKit
import Swinject

protocol RssFeedCoordinatorDelegate: class {
    func rssFeedCoordinatorDidFinish()
}

class RssFeedCoordinator: NavigationCoordinator {

    // MARK: - Properties

    let navigationController: UINavigationController
    let container: Container
    weak var delegate: RssFeedCoordinatorDelegate?
    init(container: Container, navigationController: UINavigationController) {
        self.container = container
        self.navigationController = navigationController
    }

    // MARK: - Coordinator core

    func start() {
        let isTransitionFromSetup = navigationController.viewControllers.count > 0
        let vc = container.resolveViewController(RssFeedViewController.self)
        vc.delegate = self
        vc.navigationItem.hidesBackButton = true
        navigationController.pushViewController(vc, animated: true)
        if isTransitionFromSetup {
            navigationController.viewControllers.remove(at: 0)
        }
    }

    private func showDetail(item: RssItem) {
        let vc = container.resolveViewController(RssItemViewController.self)
        vc.viewModel.item = item
        navigationController.setBackButton()
        navigationController.pushViewController(vc, animated: true)
    }
}

// MARK: - Delegate

extension RssFeedCoordinator: RssFeedViewControllerDelegeate {
    func userDidRequesrtSetup() {
        delegate?.rssFeedCoordinatorDidFinish()
    }

    func userDidRequestItemDetail(item: RssItem) {
        showDetail(item: item)
    }
}
