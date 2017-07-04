//
//  StorageService.swift
//  MeditationWatch Extension
//
//  Created by Artem Goncharov on 02/07/2017.
//  Copyright © 2017 MadMag. All rights reserved.
//

import Foundation

protocol StorageService {
    var fastTimeChoicesConfiguration: FastTimeChoicesConfiguration? {get set}
    func addFastChoice(_ choice: FastTimeChoice)
    func changeFastChoice(at index: Int, to choice: FastTimeChoice)
    func removeChoice(at index: Int)
}

class StorageServiceDefaultsImpl: StorageService {
    var fastTimeChoicesConfiguration: FastTimeChoicesConfiguration? {
        get {
            guard let choices = UserDefaults.standard.fastTimeChoices,
                let lastSitTime = UserDefaults.standard.lastSitTime else {
                    return nil
            }
            return FastTimeChoicesConfiguration(fastTimeChoices: choices.map({return FastTimeChoice(value: $0)}),
                                                lastSitTime: lastSitTime)
        }
        
        set {
            UserDefaults.standard.fastTimeChoices = newValue?.fastTimeChoices.map({return $0.value})
            UserDefaults.standard.lastSitTime = newValue?.lastSitTime
        }
    }
    
    func addFastChoice(_ choice: FastTimeChoice) {
        guard let configuration = fastTimeChoicesConfiguration, configuration.fastTimeChoices.count < maxFastChoicesNumber else {
            return
        }
        
        fastTimeChoicesConfiguration = choicesLens.set(configuration, configuration.fastTimeChoices + [choice])
    }
    
    func changeFastChoice(at index: Int, to choice: FastTimeChoice) {
        guard let configuration = fastTimeChoicesConfiguration, configuration.fastTimeChoices.count > index else {
            return
        }
        var tempChoices = configuration.fastTimeChoices
        tempChoices[index] = choice
        
        fastTimeChoicesConfiguration = choicesLens.set(configuration, tempChoices)
    }
    
    func removeChoice(at index: Int) {
        guard let configuration = fastTimeChoicesConfiguration, configuration.fastTimeChoices.count > index else {
            return
        }
        var tempChoices = configuration.fastTimeChoices
        tempChoices.remove(at: index)
        
        fastTimeChoicesConfiguration = choicesLens.set(configuration, tempChoices)
    }
}

private extension UserDefaults {
    var fastTimeChoices: [UInt]? {
        get { return object(forKey: #function) as? [UInt] ?? nil }
        set { set(newValue, forKey: #function) }
    }
    var lastSitTime:UInt? {
        get { return object(forKey: #function) as? UInt ?? nil }
        set { set(newValue, forKey: #function) }
    }
}
