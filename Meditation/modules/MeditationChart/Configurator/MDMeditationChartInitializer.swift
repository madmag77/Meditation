//
//  MDMeditationChartMDMeditationChartInitializer.swift
//  Meditation
//
//  Created by Artem on 25/06/2017.
//  Copyright © 2017 MagMag77. All rights reserved.
//

import UIKit

class MeditationChartModuleInitializer: NSObject {

    //Connect with object on storyboard
    @IBOutlet weak var meditationchartViewController: MeditationChartViewController!

    override func awakeFromNib() {

        let configurator = MeditationChartModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: meditationchartViewController)
    }

}
