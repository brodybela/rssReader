//
//  RssFeedViewController
//  rssReader
//
//  Created by Brody Bela on 27/09/2017.
//  Copyright © 2017 Brody Media. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import CRToast

protocol RssFeedViewControllerDelegeate: class {
    func userDidRequestItemDetail(item: RssItem)
    func userDidRequesrtSetup()
}

class RssFeedViewController: UIViewController, FeedStoryboardLodable {

    // MARK: - Outlets

    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Properties

    var viewModel: RssFeedViewModel!
    weak var delegate: RssFeedViewControllerDelegeate?

    // MARK: - Fields

    private var disposeBag = DisposeBag()
    private let refreshControl: UIRefreshControl
    private let addButton: UIBarButtonItem

    required init?(coder aDecoder: NSCoder) {
        refreshControl = UIRefreshControl()
        addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: nil, action: nil)
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupBinding()
        setupData()
    }

    // MARK: - Setup

    private func setupUI() {
        title = viewModel.title
        tableView.estimatedRowHeight = 0
        tableView.refreshControl = refreshControl
        refreshControl.attributedTitle = NSAttributedString(string: "pull_to_refresh".localized)
        navigationItem.rightBarButtonItem = addButton
    }

    private func setupBinding() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)

        tableView.rx.modelSelected(RssItem.self).subscribe(onNext: { [weak self] item in self?.delegate?.userDidRequestItemDetail(item: item) }).disposed(by: disposeBag)
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in self?.tableView.deselectRow(at: indexPath, animated: true) }).disposed(by: disposeBag)

        refreshControl.rx.controlEvent(.valueChanged).bind(to: viewModel.load).disposed(by: disposeBag)
        viewModel.feed.observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] items in
            self?.refreshControl.endRefreshing()
            if items.count == 0 {
                CRToastManager.showErrorNotification(title: "network_problem".localized)
            }
        }).disposed(by: disposeBag)
        addButton.rx.tap.subscribe(onNext: { [weak self] in self?.delegate?.userDidRequesrtSetup() }).disposed(by: disposeBag)
    }

    private func setupData() {
        tableView.register(cellType: RssFeedCell.self)

        viewModel.feed
            .bind(to: tableView.rx.items(cellIdentifier: RssFeedCell.reuseIdentifier, cellType: RssFeedCell.self)) { _, element, cell in
                cell.model = element
            }
            .disposed(by: disposeBag)
    }
}

extension RssFeedViewController: UITableViewDelegate {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 100
    }
}
