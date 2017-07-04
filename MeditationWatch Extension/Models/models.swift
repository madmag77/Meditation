//
//  models.swift
//  MeditationWatch Extension
//
//  Created by Artem Goncharov on 02/07/2017.
//  Copyright © 2017 MadMag. All rights reserved.
//

import Foundation

let defaultMeditationTimePeriod: UInt = 30
let maxFastChoicesNumber = 6

let defualtConfiguration: FastTimeChoicesConfiguration = FastTimeChoicesConfiguration(fastTimeChoices: [FastTimeChoice(value: defaultMeditationTimePeriod)], lastSitTime: 0)

struct FastTimeChoice {
    let value: UInt
}

struct FastTimeChoicesConfiguration {
    let fastTimeChoices: [FastTimeChoice]
    let lastSitTime: UInt
}

let choicesLens = Lens<FastTimeChoicesConfiguration, [FastTimeChoice]> (
    get: { configuration in
        return configuration.fastTimeChoices
    },
    set: { configuration, newChoices in
        return FastTimeChoicesConfiguration(fastTimeChoices: newChoices, lastSitTime: configuration.lastSitTime)
    }
)

struct Lens<Whole, Part> {
    let get: (Whole) -> Part
    let set: (Whole, Part) -> Whole
}
