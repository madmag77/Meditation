//
//  MDMeditationChartMDMeditationChartConfigurator.swift
//  Meditation
//
//  Created by Artem on 25/06/2017.
//  Copyright © 2017 MagMag77. All rights reserved.
//

import UIKit

class MeditationChartModuleConfigurator {

    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController) {

        if let viewController = viewInput as? MeditationChartViewController {
            configure(viewController: viewController)
        }
    }

    private func configure(viewController: MeditationChartViewController) {

        let router = MeditationChartRouter()

        let presenter = MeditationChartPresenter()
        presenter.view = viewController
        presenter.router = router

        let interactor = MeditationChartInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter
    }

}
