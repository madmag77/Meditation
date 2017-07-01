//
//  FastTimeChoiceController.swift
//  Meditation
//
//  Created by Artem Goncharov on 01/07/2017.
//  Copyright © 2017 MadMag. All rights reserved.
//

import Foundation

import WatchKit
import Foundation

class FastTimeChoiceController: WKInterfaceController {
    
    @IBOutlet var time1Btn: WKInterfaceButton!
    @IBOutlet var time2Btn: WKInterfaceButton!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

   
    }
    
    @IBAction func addMenuTap() {
        presentController(withName: "EditTimeController", context: nil)
    }
    
    @IBAction func tapOnBtn1(_ sender: Any) {
        pushController(withName: "TimerController", context: nil)
    }
    
    @IBAction func longTapOnBtn1(_ sender: Any) {
        presentController(withName: "EditTimeController", context: nil)
    }
}
