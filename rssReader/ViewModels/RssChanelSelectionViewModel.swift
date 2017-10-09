//
//  RssChanelSelectionViewModel.swift
//  rssReader
//
//  Created by Brody Bela on 27/09/2017.
//  Copyright © 2017 Brody Media. All rights reserved.
//

import Foundation
import RxSwift
import CleanroomLogger

class RssChanelSelectionViewModel {

    // MARK: - Properties

    let chanels: Observable<[RssChanelViewModel]>
    let filter = Variable<String?>(nil)
    let isValid: Observable<Bool>

    // MARK: - Fields

    private let allChanels = Variable<[RssChanelViewModel]>([])
    private let settingsService: SettingsService
    private var disposeBag = DisposeBag()

    init(settingsService: SettingsService) {
        self.settingsService = settingsService

        Log.debug?.message("Loading chanels")

        let jsonData = Bundle.loadFile(filename: "data.json")!

        let jsonDecoder = JSONDecoder()
        let all = (try! jsonDecoder.decode(Array<RssChanel>.self, from: jsonData)).map({ RssChanelViewModel(chanel: $0) })

        chanels = Observable.combineLatest(allChanels.asObservable(), filter.asObservable()) {
            (all: [RssChanelViewModel], filter: String?) -> [RssChanelViewModel] in
            if let filter = filter, !filter.isEmpty {
                return all.filter({ $0.chanel.title.lowercased().contains(filter.lowercased()) })
            } else {
                return all
            }
        }

        isValid = chanels.asObservable().flatMap { Observable.combineLatest($0.map { $0.isSelected.asObservable() }) }.map({ $0.filter({ $0 }).count == 1 })

        allChanels.value.append(contentsOf: all)

        // selecting again from feed
        if let selected = settingsService.selectedChanel {
            if let index = allChanels.value.index(where: { $0.chanel == selected }) { // pre-selecting the current chanel
                allChanels.value[index].isSelected.value = true
            } else { // using a custom chanel
                let vm = RssChanelViewModel(chanel: selected)
                vm.isSelected.value = true
                allChanels.value.insert(vm, at: 0)
            }
        }
    }

    // MARK: - Actions

    func toggleChanel(chanel: RssChanelViewModel) {
        let selected = chanel.isSelected.value

        for s in allChanels.value {
            s.isSelected.value = false
        }

        chanel.isSelected.value = !selected
    }

    func addNewChanel(chanel: RssChanel) {
        let vm = RssChanelViewModel(chanel: chanel)
        allChanels.value.insert(vm, at: 0)
        toggleChanel(chanel: vm)
    }

    func saveSelectedChanel() -> Bool {
        guard let selected = allChanels.value.first(where: { $0.isSelected.value }) else {
            Log.error?.message("Cannot save, no chanel selected")
            return false
        }

        settingsService.selectedChanel = selected.chanel
        return true
    }
}
