//
//  FastTimeModuleBuilder.swift
//  MeditationWatch Extension
//
//  Created by Artem Goncharov on 02/07/2017.
//  Copyright © 2017 MadMag. All rights reserved.
//

import Foundation

protocol FastTimeModuleBuilder {
     func buildPresenter(with view: FastTimeChoiceViewInput) -> FastTimeChoiceViewOutput
}

class FastTimeModuleBuilderImpl: FastTimeModuleBuilder {
    func buildPresenter(with view: FastTimeChoiceViewInput) -> FastTimeChoiceViewOutput {
        let presenter = FastTimeChoicePresenter()
        let interactor = FastTimeChoiceInteractor()
        let router = FastTimeChoiceRouter()
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        interactor.output = presenter
        interactor.storageService = StorageServiceDefaultsImpl()
        
        router.controller = view as! FastTimeChoiceController
        
        return presenter
    }

}
