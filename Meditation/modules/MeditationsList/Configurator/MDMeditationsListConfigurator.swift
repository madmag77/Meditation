//
//  MDMeditationsListMDMeditationsListConfigurator.swift
//  Meditation
//
//  Created by Artem on 25/06/2017.
//  Copyright © 2017 MagMag77. All rights reserved.
//

import UIKit

class MeditationsListModuleConfigurator {

    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController) {

        if let viewController = viewInput as? MeditationsListViewController {
            configure(viewController: viewController)
        }
    }

    private func configure(viewController: MeditationsListViewController) {

        let router = MeditationsListRouter()

        let presenter = MeditationsListPresenter()
        presenter.view = viewController
        presenter.router = router

        let interactor = MeditationsListInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter
    }

}
