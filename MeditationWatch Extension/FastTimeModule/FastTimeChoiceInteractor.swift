//
//  FastTimeChoiceInteractor.swift
//  Meditation
//
//  Created by Artem Goncharov on 02/07/2017.
//  Copyright © 2017 MadMag. All rights reserved.
//

import Foundation

protocol FastTimeChoiceInteractorInput {
    func getFastChoicesConfiguration() -> FastTimeChoicesConfiguration
}

class FastTimeChoiceInteractor  {
    weak var output: FastTimeChoiceInteractorOutput!
    var storageService: StorageService!
    
    init() {
    }
}

extension FastTimeChoiceInteractor: FastTimeChoiceInteractorInput {
    func getFastChoicesConfiguration() -> FastTimeChoicesConfiguration {
        if storageService.fastTimeChoicesConfiguration == nil {
            storageService.fastTimeChoicesConfiguration = defualtConfiguration
        }
        return storageService.fastTimeChoicesConfiguration ?? defualtConfiguration
    }
}
