//
//  MeditationChartMDMeditationChartPresenter.swift
//  Meditation
//
//  Created by Artem on 25/06/2017.
//  Copyright © 2017 MagMag77. All rights reserved.
//

class MeditationChartPresenter: MeditationChartModuleInput, MeditationChartViewOutput, MeditationChartInteractorOutput {

    weak var view: MeditationChartViewInput!
    var interactor: MeditationChartInteractorInput!
    var router: MeditationChartRouterInput!

    func viewIsReady() {

    }
}
