//
//  RssItemViewController.swift
//  rssReader
//
//  Created by Brody Bela on 27/09/2017.
//  Copyright © 2017 Brody Media. All rights reserved.
//

import UIKit
import CleanroomLogger
import RxSwift
import RxCocoa

class RssItemViewController: UIViewController, FeedStoryboardLodable {

    // MARK: - Outlets

    @IBOutlet private weak var webView: UIWebView!

    // MARK: - Properties

    var viewModel: RssItemViewModel!
    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupBinding()
        setupData()
    }

    // MARK: - Setup

    private func setupUI() {
        title = viewModel.item.title
    }

    private func setupData() {
        if let link = viewModel.item.link, let url = URL(string: link) {
            webView.loadRequest(NSURLRequest(url: url) as URLRequest)
        }
    }

    private func setupBinding() {
        webView.rx.didStartLoad.subscribe(onNext: { UIApplication.shared.isNetworkActivityIndicatorVisible = true }).disposed(by: disposeBag)
        webView.rx.didFinishLoad.subscribe(onNext: { UIApplication.shared.isNetworkActivityIndicatorVisible = false }).disposed(by: disposeBag)
        webView.rx.didFailLoad.subscribe(onNext: { error in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            Log.error?.message("Webview loading failed with \(error.localizedDescription)")
        }).disposed(by: disposeBag)
    }

    override func viewDidDisappear(_: Bool) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
