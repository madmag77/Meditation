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
    var storageService: StorageService = StorageServiceDefaultsImpl()
    var choiceToAdd: FastTimeChoice?
    var choiceIndexToChange: Int?
    var pickerValue: Int = 0
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        switch context {
        case let context as (FastTimeChoice, Int):
            choiceToAdd = context.0
            choiceIndexToChange = context.1
        case let context as FastTimeChoice:
            choiceToAdd = context
        case let context as Int:
            choiceIndexToChange = context
        default:
            choiceIndexToChange = nil
        }
        
        let pickerItems: [WKPickerItem] = (1...24).map {
            let pickerItem = WKPickerItem()
            pickerItem.contentImage = WKImage(imageName: "0\($0*5)prog.png")
            return pickerItem
        }
        periodPicker.setItems(pickerItems)
        
        guard let choice = choiceToAdd else {
            return
        }
        
        periodPicker.setSelectedItemIndex(Int(choice.value / 5) - 1)
    }
    
    @IBAction func addBtnTap() {
        if choiceToAdd == nil {
            storageService.addFastChoice(FastTimeChoice(value: UInt((pickerValue + 1) * 5)))
        } else if choiceIndexToChange != nil {
            storageService.changeFastChoice(at: choiceIndexToChange!, to: FastTimeChoice(value: UInt((pickerValue + 1) * 5)))
        }
        
        dismiss()
    }

    @IBAction func pickerDidChoose(_ value: Int) {
        pickerValue = value
    }
    
    @IBAction func deleteBtnTap() {
        if choiceIndexToChange != nil {
            storageService.removeChoice(at: choiceIndexToChange!)
        }
        dismiss()
    }
}
