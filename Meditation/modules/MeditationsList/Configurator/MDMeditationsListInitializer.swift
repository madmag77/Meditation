//
//  MDMeditationsListMDMeditationsListInitializer.swift
//  Meditation
//
//  Created by Artem on 25/06/2017.
//  Copyright © 2017 MagMag77. All rights reserved.
//

import UIKit

class MeditationsListModuleInitializer: NSObject {

    //Connect with object on storyboard
    @IBOutlet weak var meditationslistViewController: MeditationsListViewController!

    override func awakeFromNib() {

        let configurator = MeditationsListModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: meditationslistViewController)
    }

}
