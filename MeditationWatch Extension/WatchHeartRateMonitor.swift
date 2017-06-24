//
//  WatchHeartRateMonitor.swift
//  Meditation
//
//  Created by Artem Goncharov on 24/06/2017.
//  Copyright © 2017 MadMag. All rights reserved.
//

import Foundation
import HealthKit

public class WatchHeartRateMonitor: NSObject {
    var workoutSession: HKWorkoutSession?
    var healthStore: HKHealthStore = HKHealthStore()
    var workoutStartDate: Date! = Date()
    let configuration = HKWorkoutConfiguration()
    
    var isMonitoring: Bool = false {
        didSet {
            if isMonitoring {
                startMonitoring()
            } else {
                stopMonitoring()
            }
        }
    }
        
    fileprivate func startMonitoring() {
        var readDataTypes: Set<HKObjectType> = Set<HKObjectType>()
        readDataTypes.insert(HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!)
        readDataTypes.insert(HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.mindfulSession)!)
        
        var writeDataTypes: Set<HKSampleType> = Set<HKSampleType>()
        writeDataTypes.insert(HKSampleType.categoryType(forIdentifier: HKCategoryTypeIdentifier.mindfulSession)!)
        
        self.healthStore.requestAuthorization(toShare: writeDataTypes, read: readDataTypes) { (success, error) in
            if !success {
                print(error.debugDescription)
            }
        }
        
        workoutStartDate = Date()
        
        configuration.activityType = .mindAndBody
        configuration.locationType = .indoor
        
        do {
            workoutSession = try HKWorkoutSession(configuration: configuration)
            
            workoutSession!.delegate = self
            healthStore.start(workoutSession!)
        }
        catch let error as NSError {
            // Perform proper error handling here...
            fatalError("*** Unable to create the workout session: \(error.localizedDescription) ***")
        }
        
        // Start the workout session
        
        // This is the type you want updates on. It can be any health kit type, including heart rate.
        let heartRateType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)
        
        // Match samples with a start date after the workout start
        let predicate = HKQuery.predicateForSamples(withStart: workoutStartDate, end: nil, options: [])
        
        let heartRateQuery = HKAnchoredObjectQuery(type: heartRateType!,
                                                   predicate: predicate,
                                                   anchor: HKQueryAnchor(fromValue: Int(HKAnchoredObjectQueryNoAnchor)),
                                                   limit: 0) { (query, newSamples, deletedSamples, newAnchor, error) -> Void in
                                                    print("query:\n")
                                                    for sample in newSamples! {
                                                        print(sample)
                                                    }
        }
        
        // This is called each time a new value is entered into HealthKit (samples may be batched together for efficiency)
        heartRateQuery.updateHandler = { (query, samples, deletedObjects, anchor, error) -> Void in
            print("update:\n")
            for sample in samples! {
                print(sample)
            }
        }
        
        // Start the query
        healthStore.execute(heartRateQuery)
    }
    
    func stopMonitoring() {
        healthStore.end(workoutSession!)
    }
}

extension WatchHeartRateMonitor: HKWorkoutSessionDelegate {
    public func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        print("toState \(toState)")
        
        if toState == .ended {
            // Now create the sample
            let smpleObject = HKCategorySample(type: HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.mindfulSession)!, value: HKCategoryValue.notApplicable.rawValue, start: workoutSession.startDate!, end: workoutSession.endDate!)
            
            // Save the workout before adding detailed samples.
            healthStore.save(smpleObject) { (success, error) -> Void in
                guard success else {
                    // Perform proper error handling here...
                    fatalError("*** An error occurred while saving the " +
                        "workout: \(error?.localizedDescription)")
                }
            }
        }
    }
    
    public func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        print("error \(error)")
    }
}
