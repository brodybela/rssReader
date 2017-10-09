//
//  AppCoordinator.swift
//  rssReader
//
//  Created by Brody Bela on 27/09/2017.
//  Copyright © 2017 Brody Media. All rights reserved.
//

import Foundation
import Swinject
import UIKit
import CleanroomLogger

class AppCoordinator: Coordinator {

    // MARK: - Coordinator keys

    private let NEWRSSKEY: String = "NEWRss"
    private let RSSFEEDKEY: String = "RSSFeed"

    // MARK: - Properties

    private let window: UIWindow
    let container: Container
    private var childCoordinators = [String: Coordinator]()
    private let settingsService: SettingsService
    private let navigationController: UINavigationController

    // MARK: - Coordinator

    init(window: UIWindow, container: Container) {
        self.window = window
        self.container = container
        navigationController = UINavigationController()
        settingsService = self.container.resolve(SettingsService.self)!
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.view.backgroundColor = UIColor.white
        self.window.rootViewController = navigationController
    }

    func start() {
        if settingsService.selectedChanel != nil {
            Log.debug?.message("Setup complete, starting dahsboard")
            showFeed()
        } else {
            Log.debug?.message("Startipng setup")
            showChanel()
        }
    }

    private func showFeed() {
        let rssFeedCoordinator = RssFeedCoordinator(container: container, navigationController: navigationController)
        childCoordinators[RSSFEEDKEY] = rssFeedCoordinator
        rssFeedCoordinator.delegate = self
        rssFeedCoordinator.start()
    }

    private func showChanel() {
        let setupCoordinator = SetupCoordinator(container: container, navigationController: navigationController)
        childCoordinators[NEWRSSKEY] = setupCoordinator
        setupCoordinator.delegate = self
        setupCoordinator.start()
    }
}

extension AppCoordinator: SetupCoordinatorDelegate {
    func setupCoordinatorDidFinish() {
        showFeed()
    }
}

extension AppCoordinator: RssFeedCoordinatorDelegate {
    func rssFeedCoordinatorDidFinish() {
        showChanel()
    }
}
