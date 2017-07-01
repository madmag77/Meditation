//
//  EditTimeController.swift
//  Meditation
//
//  Created by Artem Goncharov on 01/07/2017.
//  Copyright © 2017 MadMag. All rights reserved.
//

import Foundation

import WatchKit
import Foundation

class EditTimeController: WKInterfaceController {
   
    @IBOutlet var periodPicker: WKInterfacePicker!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        let pickerItems: [WKPickerItem] = (1...24).map {
            let pickerItem = WKPickerItem()
            pickerItem.contentImage = WKImage(imageName: "0\($0*5)prog.png")
            return pickerItem
        }
        periodPicker.setItems(pickerItems)
    }
    
    @IBAction func addBtnTap() {
        dismiss()
    }

    @IBAction func deleteBtnTap() {
        dismiss()
    }
}
