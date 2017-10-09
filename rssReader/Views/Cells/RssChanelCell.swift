//
//  RssChanelCell.swift
//  rssReader
//
//  Created by Brody Bela on 27/09/2017.
//  Copyright © 2017 Brody Media. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxNuke
import Nuke

class RssChanelCell: UITableViewCell, NibReusable {

    // MARK: - Outlets

    @IBOutlet private weak var chanelLogo: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var urlLabel: UILabel!

    // MARK: - Properties

    var viewModel: RssChanelViewModel? {
        didSet {
            if let vm = viewModel {
                disposeBag = DisposeBag()

                titleLabel.text = vm.chanel.title
                urlLabel.text = vm.chanel.url
                vm.isSelected.asObservable().subscribe(onNext: { [weak self] selected in
                    self?.accessoryType = selected ? .checkmark : .none
                }).disposed(by: disposeBag)
                chanelLogo.image = nil
                if let logo = vm.chanel.logo, let logoUrl = URL(string: logo) {
                    Nuke.Manager.shared.loadImage(with: logoUrl)
                        .observeOn(MainScheduler.instance)
                        .subscribe(onSuccess: { [weak self] in self?.chanelLogo.image = $0 })
                        .disposed(by: disposeBag)
                }
            }
        }
    }

    // MARK: - Fields

    private var disposeBag = DisposeBag()
}
