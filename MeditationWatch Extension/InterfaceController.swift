//
//  InterfaceController.swift
//  MeditationWatch Extension
//
//  Created by Artem Goncharov on 24/06/2017.
//  Copyright © 2017 MadMag. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {
    @IBOutlet var periodPicker: WKInterfacePicker!
    @IBOutlet var startBtn: WKInterfaceButton!
    @IBOutlet var timer: WKInterfaceTimer!
    @IBOutlet var heartRateLabel: WKInterfaceLabel!
    
    var countDownTimer: Timer?
    lazy var hrMonitor: WatchHeartRateMonitor = {
        WatchHeartRateMonitor(with: self as WatchHeartRateMonitorDelegate)
    } ()
    
    var selectedPeriod: Int = 0
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        var items: [WKPickerItem] = []
        for i in 2..<7 {
            let item = WKPickerItem()
            item.title = "\(i*10) min"
            items.append(item)
        }
        periodPicker.setItems(items)
        periodPicker.setEnabled(true)
    }
    
    override func willActivate() {
        periodPicker.setSelectedItemIndex(selectedPeriod)
        
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func periodChoosed(_ value: Int) {
        selectedPeriod = value
    }
    
    @IBAction func startBtnTap() {
        hrMonitor.isMonitoring = !hrMonitor.isMonitoring
        hrMonitor.isMonitoring ? startMonitoring() : stopMonitoring()
    }
    
    internal func startMonitoring() {
        periodPicker.setEnabled(false)
        startBtn.setTitle("Stop")
        startTimer()
        notifyUserMeditationStarts()
    }
    
    internal func stopMonitoring() {
        periodPicker.setEnabled(true)
        startBtn.setTitle("Start")
        stopTimer()
        notifyUserMeditationStop()
    }
    
    internal func notifyUserMeditationStop() {
        WKInterfaceDevice().play(.stop)
    }
    
    internal func notifyUserMeditationStarts() {
        WKInterfaceDevice().play(.start)
    }
    
    internal func startTimer() {
        let interval = TimeInterval(selectedPeriod * 10 * 60)
        timer.stop()
        timer.setDate(Date(timeInterval: interval, since: Date()))
        timer.start()
        countDownTimer = Timer(timeInterval: interval, repeats: false, block: {_ in
            self.stopMonitoring()
        })
    }
    
    internal func stopTimer() {
         timer.stop()
    }
}

extension InterfaceController: WatchHeartRateMonitorDelegate {
    func updateHeartRate(_ value: Double) {
        heartRateLabel.setText("\(Int(value)) \(heartRateUnitString)")
    }
    
    
}
