//
//  MDMeditationsListMDMeditationsListInteractorInput.swift
//  Meditation
//
//  Created by Artem on 25/06/2017.
//  Copyright © 2017 MagMag77. All rights reserved.
//

import Foundation

protocol MeditationsListInteractorInput {
    func isDataAvailable()
    func meditaionList(from startDate: Date, to endDate: Date)
}
