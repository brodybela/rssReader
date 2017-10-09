//
//  NewChanelViewController.swift
//  rssReader
//
//  Created by Brody Bela on 27/09/2017.
//  Copyright © 2017 Brody Media. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol NewChanelViewControllerDelegate: class {
    func userDidAddNewChanel(chanel: RssChanel)
}

class NewChanelViewController: UIViewController, SetupStoryboardLodable {

    // MARK: - Outlets

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var urlLabel: UILabel!
    @IBOutlet private weak var urlTextField: UITextField!
    @IBOutlet private weak var rssUrlLabel: UILabel!
    @IBOutlet private weak var rssUrlTextField: UITextField!
    @IBOutlet private weak var logoUrlLabel: UILabel!
    @IBOutlet private weak var logoUrlTextField: UITextField!
    @IBOutlet private weak var scrollview: UIScrollView!

    // MARK: - Properties

    var viewModel: NewChanelViewModel!
    weak var delegate: NewChanelViewControllerDelegate?

    // MARK: - Fields

    private var disposeBag = DisposeBag()
    private let doneButton = UIBarButtonItem(title: "Done".localized, style: .plain, target: nil, action: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupBinding()
    }

    // MARK: - Setup

    private func setupUI() {
        title = "Add New Chanel".localized
        navigationItem.rightBarButtonItem = doneButton

        titleLabel.text = "title".localized
        rssUrlLabel.text = "rss_url".localized
        logoUrlLabel.text = "\("logo_url".localized) (\("optional".localized))"
        urlLabel.text = "url".localized
    }

    private func setupBinding() {
        viewModel.isValid.bind(to: doneButton.rx.isEnabled).disposed(by: disposeBag)
        titleTextField.rx.text.bind(to: viewModel.title).disposed(by: disposeBag)
        urlTextField.rx.text.bind(to: viewModel.url).disposed(by: disposeBag)
        rssUrlTextField.rx.text.bind(to: viewModel.rssUrl).disposed(by: disposeBag)
        logoUrlTextField.rx.text.bind(to: viewModel.logoUrl).disposed(by: disposeBag)

        viewModel.rssUrl.asObservable().map({ $0?.isValidURL == true }).map(validityToColor).bind(to: rssUrlTextField.rx.textColor).disposed(by: disposeBag)
        viewModel.url.asObservable().map({ $0?.isValidURL == true }).map(validityToColor).bind(to: urlTextField.rx.textColor).disposed(by: disposeBag)
        viewModel.logoUrl.asObservable().map({ $0?.isValidURL == true }).map(validityToColor).bind(to: logoUrlTextField.rx.textColor).disposed(by: disposeBag)

        NotificationCenter.default.rx.keyboardHeightChanged().subscribe(onNext: { [weak self] height in self?.scrollview.setBottomInset(height: height) }).disposed(by: disposeBag)

        doneButton.rx.tap.subscribe(onNext: { [unowned self] in self.delegate?.userDidAddNewChanel(chanel: self.viewModel.getCreatedChanel()) }).disposed(by: disposeBag)
    }

    private func validityToColor(_ isValid: Bool) -> UIColor {
        return isValid ? UIColor.black : UIColor.red
    }
}
