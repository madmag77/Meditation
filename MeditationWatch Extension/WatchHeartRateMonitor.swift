//
//  WatchHeartRateMonitor.swift
//  Meditation
//
//  Created by Artem Goncharov on 24/06/2017.
//  Copyright © 2017 MadMag. All rights reserved.
//

import Foundation
import HealthKit

let heartRateUnitString: String = "count/min"
let meditationHKObjectType = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.mindfulSession)!
let heartRateHKObjectType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!

public protocol WatchHeartRateMonitorDelegate: class {
    func updateHeartRate(_ value: Double)
}

public class WatchHeartRateMonitor: NSObject {
    var workoutSession: HKWorkoutSession?
    var healthStore: HKHealthStore = HKHealthStore()
    let readDataTypes: Set<HKObjectType> = [heartRateHKObjectType, meditationHKObjectType]
    let writeDataTypes: Set<HKSampleType> = [meditationHKObjectType]
    var heartRateQuery: HKAnchoredObjectQuery?
    
    lazy var configuration: HKWorkoutConfiguration = {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .mindAndBody
        configuration.locationType = .indoor
        return configuration
    } ()
    
    let heartRateUnit: HKUnit = HKUnit(from: heartRateUnitString)
    
    var isMonitoring: Bool = false {
        didSet {
            if isMonitoring {
                startMonitoring()
            } else {
                stopMonitoring()
            }
        }
    }
    
    weak var delegate: WatchHeartRateMonitorDelegate?
    
    public init(with delegate: WatchHeartRateMonitorDelegate?) {
        super.init()
        self.delegate = delegate
    }
    
    fileprivate func requestAuthorization() {
        self.healthStore.requestAuthorization(toShare: writeDataTypes, read: readDataTypes) { (success, error) in
            if !success {
                //TODO: Perform proper error handling here...
                fatalError("*** Unable to create the workout session: \(String(describing: error?.localizedDescription)) ***")
            }
        }
    }
        
    fileprivate func startMonitoring() {
        requestAuthorization()
        
        do {
            workoutSession = try HKWorkoutSession(configuration: configuration)
            workoutSession!.delegate = self
            healthStore.start(workoutSession!)
        }
        catch let error as NSError {
            //TODO: Perform proper error handling here...
            fatalError("*** Unable to create the workout session: \(error.localizedDescription) ***")
        }
    }
    
    fileprivate func stopMonitoring() {
        healthStore.end(workoutSession!)
    }
    
    fileprivate func workoutStarted() {
        startDataQuering()
    }
    
    fileprivate func workoutEnded() {
        saveMeditationInStore()
        stopDataQuering()
    }
    
    fileprivate func startDataQuering() {
        let predicate = HKQuery.predicateForSamples(withStart: workoutSession?.startDate, end: nil, options: [])
        
        heartRateQuery = HKAnchoredObjectQuery(type: heartRateHKObjectType,
                                               predicate: predicate,
                                               anchor: HKQueryAnchor(fromValue: Int(HKAnchoredObjectQueryNoAnchor)),
                                               limit: 0) { (query, newSamples, deletedSamples, newAnchor, error) -> Void in
                                                //not needed to process archive data
        }
        
        guard let heartRateQuery = heartRateQuery else {
            return
        }
        
        heartRateQuery.updateHandler = { (query, samples, deletedObjects, anchor, error) -> Void in
            guard let sample = samples?.last, let data: HKQuantitySample = sample as? HKQuantitySample else {
                return
            }
            
            self.delegate?.updateHeartRate(data.quantity.doubleValue(for: self.heartRateUnit))
        }
        
        healthStore.execute(heartRateQuery)
    }
    
    fileprivate func stopDataQuering() {
        guard let heartRateQuery = heartRateQuery else {
            return
        }

        healthStore.stop(heartRateQuery)
    }
    
    fileprivate func saveMeditationInStore() {
        guard let workoutSession = workoutSession, let startDate = workoutSession.startDate, let endDate = workoutSession.endDate else {
            return
        }
        let smpleObject = HKCategorySample(type: meditationHKObjectType, value: HKCategoryValue.notApplicable.rawValue, start: startDate, end: endDate)
        
        healthStore.save(smpleObject) { (success, error) -> Void in
            guard success else {
                //TODO: Perform proper error handling here...
                fatalError("*** An error occurred while saving the " +
                    "workout: \(String(describing: error?.localizedDescription))")
            }
        }
    }
}

extension WatchHeartRateMonitor: HKWorkoutSessionDelegate {
    public func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        switch (fromState, toState) {
        case (.notStarted, .running):
            workoutStarted()
        case (.running, .ended):
            workoutEnded()
        default:
            return
        }
    }
    
    public func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
         //TODO: Perform proper error handling here...
        print("error \(error)")
    }
}
