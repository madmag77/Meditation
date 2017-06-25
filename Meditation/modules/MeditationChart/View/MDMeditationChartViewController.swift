//
//  MeditationChartMDMeditationChartViewController.swift
//  Meditation
//
//  Created by Artem on 25/06/2017.
//  Copyright © 2017 MagMag77. All rights reserved.
//

import UIKit

class MeditationChartViewController: UIViewController, MeditationChartViewInput {

    var output: MeditationChartViewOutput!

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }


    // MARK: MeditationChartViewInput
    func setupInitialState() {
    }
}
