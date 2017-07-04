//
//  FastTimeChoicePresenter.swift
//  MeditationWatch Extension
//
//  Created by Artem Goncharov on 02/07/2017.
//  Copyright © 2017 MadMag. All rights reserved.
//

import Foundation

protocol FastTimeChoiceViewOutput: class {
    func menuAddItemTap()
    func fastTimeBtnTap(_ btnNum: Int)
    func fastTimeBtnLongTap(_ btnNum: Int)
    func viewIsReady()
}

protocol FastTimeChoiceInteractorOutput: class {
    
}


class FastTimeChoicePresenter {
    weak var view: FastTimeChoiceViewInput!
    var interactor: FastTimeChoiceInteractor!
    var router: FastTimeChoiceRouterInput!
    
    init() {
    }
    
    func setupViewButtons(_ choices: [FastTimeChoice]) {
        for btnIndex: Int in 0..<6 {
            let choice: FastTimeChoice? = choices.count > btnIndex ? choices[btnIndex] : nil
            view.btnConfigure(btnNum: btnIndex, periodInMin: choice?.value ?? 0, hidden: choice == nil)
        }
    }
    
    func setupViewLastSitLabel(_ lastSitTime: UInt) {
        view.setLastSitTime(label: lastSitTime == 0 ? nil : "Last sit time: \(lastSitTime) min")
    }
    
    func setupViewMenu(_ choices: [FastTimeChoice]) {
        view.isMenuAvailable(choices.count != maxFastChoicesNumber)
    }
    
    func setupView(_ configuration: FastTimeChoicesConfiguration) {
        setupViewButtons(configuration.fastTimeChoices)
        setupViewMenu(configuration.fastTimeChoices)
        setupViewLastSitLabel(configuration.lastSitTime)
    }
}

extension FastTimeChoicePresenter: FastTimeChoiceViewOutput {
    func menuAddItemTap() {
        router.openAddOneMoreFastChoice()
    }
    
    func fastTimeBtnTap(_ btnNum: Int) {
        guard interactor.getFastChoicesConfiguration().fastTimeChoices.count > btnNum else {
                return
        }
        
        let choice = interactor.getFastChoicesConfiguration().fastTimeChoices[btnNum]
        router.openRunSit(choice)
    }
    
    func fastTimeBtnLongTap(_ btnNum: Int) {
        guard interactor.getFastChoicesConfiguration().fastTimeChoices.count > btnNum else {
            return
        }
        
        let choice = interactor.getFastChoicesConfiguration().fastTimeChoices[btnNum]
        router.openEditFastChoice(choice, btnNum)
    }
    
    func viewIsReady() {
        setupView(interactor.getFastChoicesConfiguration())
    }
}

extension FastTimeChoicePresenter: FastTimeChoiceInteractorOutput {
    
}

protocol FastTimeChoiceRouterInput {
    func openAddOneMoreFastChoice()
    func openEditFastChoice(_ choice: FastTimeChoice, _ btnNum: Int)
    func openRunSit(_ choice: FastTimeChoice)
}

class FastTimeChoiceRouter:FastTimeChoiceRouterInput {
    weak var controller: FastTimeChoiceController!
    
    func openAddOneMoreFastChoice() {
         controller.presentController(withName: "EditTimeController", context: nil)
    }
    
    func openEditFastChoice(_ choice: FastTimeChoice, _ btnNum: Int) {
        controller.presentController(withName: "EditTimeController", context: (choice, btnNum))
    }
    
    func openRunSit(_ choice: FastTimeChoice) {
        controller.pushController(withName: "TimerController", context: choice)
    }
}
