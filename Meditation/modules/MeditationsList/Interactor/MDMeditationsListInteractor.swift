//
//  MDMeditationsListMDMeditationsListInteractor.swift
//  Meditation
//
//  Created by Artem on 25/06/2017.
//  Copyright © 2017 MagMag77. All rights reserved.
//

import Foundation
class MeditationsListInteractor: MeditationsListInteractorInput {

    weak var output: MeditationsListInteractorOutput!
    let hkService = HKQueryService()
    
    func isDataAvailable() {
        hkService.isDataAvailable { (error) in
            if let error = error {
                self.output.errorOccured(error)
            } else {
                self.output.dataAvailable()
            }
        }
    }
    
    func meditaionList(from startDate: Date, to endDate: Date) {
        hkService.meditations(from: startDate, to: endDate) { [weak self] (meditations) in
            self?.output.meditationList(meditations)
        }
    }
}
