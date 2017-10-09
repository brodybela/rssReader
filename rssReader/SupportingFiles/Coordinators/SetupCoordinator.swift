//
//  SetupCoordinator.swift
//  rssReader
//
//  Created by Brody Bela on 27/09/2017.
//  Copyright © 2017 Brody Media. All rights reserved.
//

import Foundation
import UIKit
import CleanroomLogger
import Swinject

protocol SetupCoordinatorDelegate: class {
    func setupCoordinatorDidFinish()
}

class SetupCoordinator: NavigationCoordinator {

    // MARK: - Properties

    let navigationController: UINavigationController
    let container: Container
    weak var delegate: SetupCoordinatorDelegate?

    init(container: Container, navigationController: UINavigationController) {
        self.container = container
        self.navigationController = navigationController
    }

    // MARK: - Coordinator core

    func start() {
        showRssChanel()
    }

    private func showRssChanel() {
        let vc = container.resolveViewController(RssChanelSelectionViewController.self)
        vc.delegate = self
        navigationController.pushViewController(vc, animated: true)
    }

    private func showAddChanelForm() {
        let vc = container.resolveViewController(NewChanelViewController.self)
        vc.delegate = self
        navigationController.pushViewController(vc, animated: true)
    }
}

extension SetupCoordinator: RssChanelSelectionViewControllerDelegate {
    func rssChanelSelectionViewControllerDidFinish() {
        delegate?.setupCoordinatorDidFinish()
    }

    func userDidRequestNewChanel() {
        showAddChanelForm()
    }
}

extension SetupCoordinator: NewChanelViewControllerDelegate {
    func userDidAddNewChanel(chanel: RssChanel) {
        if navigationController.viewControllers.count > 1, let rssChanelSelectionViewController = navigationController.viewControllers[navigationController.viewControllers.count - 2] as? RssChanelSelectionViewController {
            rssChanelSelectionViewController.viewModel.addNewChanel(chanel: chanel)
        }

        navigationController.popViewController(animated: true)
    }
}
