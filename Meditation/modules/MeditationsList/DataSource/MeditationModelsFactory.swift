//
//  MeditationModelsFactory.swift
//  Meditation
//
//  Created by Artem Goncharov on 25/06/2017.
//  Copyright © 2017 MadMag. All rights reserved.
//

import Foundation
import HealthKit
import IGListKit

class MeditationModelsFactory {
    func models(from models: [Any]) -> [ListDiffable] {
        guard let models = models as? [HKSample] else {
            return []
        }
        var res: [ListDiffable] = []
        models.forEach({ (sample) in
            res.append(MeditationModel(identifier: sample.uuid.uuidString as NSString,
                                       source: sample.source.name,
                                       startDate: sample.startDate,
                                       endDate: sample.endDate))
        })
        
        return res
    }
}
