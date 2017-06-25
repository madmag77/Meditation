//
//  MeditationsListMDMeditationsListPresenter.swift
//  Meditation
//
//  Created by Artem on 25/06/2017.
//  Copyright © 2017 MagMag77. All rights reserved.
//

import Foundation
class MeditationsListPresenter: MeditationsListModuleInput, MeditationsListViewOutput  {

    weak var view: MeditationsListViewInput!
    var interactor: MeditationsListInteractorInput!
    var router: MeditationsListRouterInput!

    func viewIsReady() {
        interactor.isDataAvailable()
    }
}

extension MeditationsListPresenter: MeditationsListInteractorOutput {
    func dataAvailable() {
        interactor.meditaionList(from: Date().addingTimeInterval(-60*60*24*7), to: Date())
    }
    
    func meditationList(_ list: Array<Any>) {
        view.dataSource?.models = MeditationModelsFactory().models(from: list)
        view.dataSource?.update()
    }
    
    func errorOccured(_ error: Error) {
        print("Interactor error: \(error.localizedDescription)")
    }
}
