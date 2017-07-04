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

protocol FastTimeChoiceViewInput: class {
    func btnConfigure(btnNum: Int, periodInMin: UInt, hidden: Bool)
    func setLastSitTime(label: String?)
    func isMenuAvailable(_ menuAvailable: Bool)
}

class FastTimeChoiceController: WKInterfaceController {
    var output: FastTimeChoiceViewOutput!
    
    @IBOutlet var lastSitLabel: WKInterfaceLabel!
    @IBOutlet var fastBtn1: WKInterfaceButton!
    @IBOutlet var fastBtn2: WKInterfaceButton!
    @IBOutlet var fastBtn3: WKInterfaceButton!
    @IBOutlet var fastBtn4: WKInterfaceButton!
    @IBOutlet var fastBtn5: WKInterfaceButton!
    @IBOutlet var fastBtn6: WKInterfaceButton!
    
    var fastButtons: [WKInterfaceButton]!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        fastButtons = [fastBtn1, fastBtn2, fastBtn3, fastBtn4, fastBtn5, fastBtn6]
        output = FastTimeModuleBuilderImpl().buildPresenter(with: self)
    }
    
    override func willActivate() {
        output.viewIsReady()
    }
    
    @IBAction func addMenuTap() {
        output.menuAddItemTap()
    }
    
    @IBAction func tapOnFastBtn1() {
        output.fastTimeBtnTap(0)
    }
    
    @IBAction func tapOnFastBtn2() {
        output.fastTimeBtnTap(1)
    }
    
    @IBAction func tapOnFastBtn3() {
        output.fastTimeBtnTap(2)
    }
    
    @IBAction func tapOnFastBtn4() {
        output.fastTimeBtnTap(3)
    }
    
    @IBAction func tapOnFastBtn5() {
        output.fastTimeBtnTap(4)
    }
    
    @IBAction func tapOnFastBtn6() {
        output.fastTimeBtnTap(5)
    }
    
    @IBAction func longTapOnBtn2(_ sender: Any) {
        output.fastTimeBtnLongTap(1)
    }
    
    @IBAction func longTapOnBtn3(_ sender: Any) {
        output.fastTimeBtnLongTap(2)
    }
    
    @IBAction func longTapOnBtn4(_ sender: Any) {
        output.fastTimeBtnLongTap(3)
    }
    
    @IBAction func longTapOnBtn5(_ sender: Any) {
        output.fastTimeBtnLongTap(4)
    }
    
    @IBAction func longTapOnBtn6(_ sender: Any) {
        output.fastTimeBtnLongTap(5)
    }
    
    func btnConfigure(_ btn: WKInterfaceButton, periodInMin: UInt, hidden: Bool) {
        btn.setHidden(hidden)
        btn.setTitle("\(periodInMin)")
    }
}

extension FastTimeChoiceController: FastTimeChoiceViewInput {
    func btnConfigure(btnNum: Int, periodInMin: UInt, hidden: Bool) {
        guard btnNum < fastButtons.count else {
            return
        }
        
        btnConfigure(fastButtons[btnNum], periodInMin: periodInMin, hidden: hidden)
    }
    
    func setLastSitTime(label: String?) {
        lastSitLabel.setText(label)
    }
    
    func isMenuAvailable(_ menuAvailable: Bool) {
        clearAllMenuItems()
        guard menuAvailable else {
            return
        }
        
        addMenuItem(with: .add, title: "Add period", action: #selector(FastTimeChoiceController.addMenuTap))
    }
}
