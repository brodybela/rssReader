//
//  RssChanelSelectionViewController.swift
//  rssReader
//
//  Created by Brody Bela on 27/09/2017.
//  Copyright © 2017 Brody Media. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol RssChanelSelectionViewControllerDelegate: class {
    func rssChanelSelectionViewControllerDidFinish()
    func userDidRequestNewChanel()
}

class RssChanelSelectionViewController: UIViewController, SetupStoryboardLodable {

    // MARK: - Outlets

    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Properties

    var viewModel: RssChanelSelectionViewModel!
    weak var delegate: RssChanelSelectionViewControllerDelegate?

    // MARK: - Fields

    private var disposeBag = DisposeBag()
    private let doneButton: UIBarButtonItem
    private let addCustomButton: UIBarButtonItem
    private let searchController: UISearchController

    required init?(coder aDecoder: NSCoder) {
        doneButton = UIBarButtonItem(title: "Done".localized, style: .plain, target: nil, action: nil)
        addCustomButton = UIBarButtonItem(title: "Add new".localized, style: .plain, target: nil, action: nil)
        searchController = UISearchController(searchResultsController: nil)

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
        title = "Select RSS Chanel".localized
        navigationItem.rightBarButtonItem = doneButton
        navigationItem.leftBarButtonItem = addCustomButton

        searchController.dimsBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true

        tableView.estimatedRowHeight = 0
    }

    private func setupBinding() {
        tableView.rx.modelSelected(RssChanelViewModel.self).subscribe(onNext: { [weak self] chanel in self?.viewModel.toggleChanel(chanel: chanel) }).disposed(by: disposeBag)
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in self?.tableView.deselectRow(at: indexPath, animated: true) }).disposed(by: disposeBag)
        viewModel.isValid.bind(to: doneButton.rx.isEnabled).disposed(by: disposeBag)
        doneButton.rx.tap.subscribe(onNext: { [weak self] in
            if self?.viewModel.saveSelectedChanel() == true {
                self?.delegate?.rssChanelSelectionViewControllerDidFinish()
            }

        }).disposed(by: disposeBag)
        addCustomButton.rx.tap.subscribe(onNext: { [weak self] in self?.delegate?.userDidRequestNewChanel() }).disposed(by: disposeBag)

        searchController.searchBar.rx.text.throttle(0.1, scheduler: MainScheduler.instance).bind(to: viewModel.filter).disposed(by: disposeBag)
        searchController.searchBar.rx.textDidBeginEditing.subscribe(onNext: { [weak self] in self?.searchController.searchBar.setShowsCancelButton(true, animated: true) }).disposed(by: disposeBag)
        searchController.searchBar.rx.cancelButtonClicked.subscribe(onNext: { [weak self] in
            self?.searchController.searchBar.resignFirstResponder()
            self?.searchController.searchBar.setShowsCancelButton(false, animated: true)
            self?.viewModel.filter.value = nil
            self?.searchController.searchBar.text = nil
        }).disposed(by: disposeBag)

        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }

    private func setupData() {
        tableView.register(cellType: RssChanelCell.self)

        viewModel.chanels
            .bind(to: tableView.rx.items(cellIdentifier: RssChanelCell.reuseIdentifier, cellType: RssChanelCell.self)) { _, element, cell in
                cell.viewModel = element
            }
            .disposed(by: disposeBag)
    }
}

extension RssChanelSelectionViewController: UITableViewDelegate {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 60
    }
}
