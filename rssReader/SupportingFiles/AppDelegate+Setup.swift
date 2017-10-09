//
//  AppDelegate+Setup.swift
//  rssReader
//
//  Created by Brody Bela on 27/09/2017.
//  Copyright © 2017 Brody Media. All rights reserved.
//

import Foundation
import CleanroomLogger
import Swinject
import SwinjectAutoregistration

extension AppDelegate {

    func setupLogging() {
        var configs = [LogConfiguration]()
        let stderr = StandardStreamsLogRecorder(formatters: [XcodeLogFormatter()])
        configs.append(BasicLogConfiguration(minimumSeverity: .debug, recorders: [stderr]))
        if let osLog = OSLogRecorder(formatters: [ReadableLogFormatter()]) {
            configs.append(BasicLogConfiguration(recorders: [osLog]))
        }
        let documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        let logsPath = documentsPath.appendingPathComponent("logs")
        let fileCfg = RotatingLogFileConfiguration(minimumSeverity: .debug,
                                                   daysToKeep: 15,
                                                   directoryPath: logsPath!.path,
                                                   formatters: [ReadableLogFormatter()])
        try! fileCfg.createLogDirectory()
        configs.append(fileCfg)
        Log.enable(configuration: configs)
    }

    func setupDependencies() {
        Log.debug?.message("Registering dependencies")

        // services
        container.autoregister(SettingsService.self, initializer: UserDefaultsSettingsService.init).inObjectScope(ObjectScope.container)
        container.autoregister(DataService.self, initializer: RssDataService.init).inObjectScope(ObjectScope.container)

        // viewmodels
        container.autoregister(RssChanelSelectionViewModel.self, initializer: RssChanelSelectionViewModel.init)
        container.autoregister(NewChanelViewModel.self, initializer: NewChanelViewModel.init)
        container.autoregister(RssFeedViewModel.self, initializer: RssFeedViewModel.init)
        container.autoregister(RssItemViewModel.self, initializer: RssItemViewModel.init)

        // view controllers
        container.storyboardInitCompleted(RssChanelSelectionViewController.self) {
            r, c in c.viewModel = r.resolve(RssChanelSelectionViewModel.self)
        }
        container.storyboardInitCompleted(NewChanelViewController.self) {
            r, c in c.viewModel = r.resolve(NewChanelViewModel.self)
        }
        container.storyboardInitCompleted(RssFeedViewController.self) {
            r, c in c.viewModel = r.resolve(RssFeedViewModel.self)
        }
        container.storyboardInitCompleted(RssItemViewController.self) {
            r, c in c.viewModel = r.resolve(RssItemViewModel.self)
        }
    }
}
