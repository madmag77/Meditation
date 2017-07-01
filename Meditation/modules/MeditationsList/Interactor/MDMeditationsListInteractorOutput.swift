//
//  MDMeditationsListMDMeditationsListInteractorOutput.swift
//  Meditation
//
//  Created by Artem on 25/06/2017.
//  Copyright © 2017 MagMag77. All rights reserved.
//

import Foundation

protocol MeditationsListInteractorOutput: class {
    func dataAvailable()
    func meditationList(_ list: Array<Any>)
    func errorOccured(_ error: Error)
}
