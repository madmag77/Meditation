//
//  ViewController.swift
//  Meditation
//
//  Created by Artem Goncharov on 12/06/2017.
//  Copyright © 2017 MadMag. All rights reserved.
//
import HealthKit
import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timePicker: UIPickerView!
    
    var workoutSession: HKWorkoutSession?
    var healthStore: HKHealthStore = HKHealthStore()
    var workoutStartDate: Date! = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assert(HKHealthStore.isHealthDataAvailable())
        
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tapOnMeditate(_ sender: Any) {
        // Create a new workout session
        workoutStartDate = Date()
        self.workoutSession = HKWorkoutSession(activityType: .running, locationType: .indoor)
        self.workoutSession!.delegate = self as HKWorkoutSessionDelegate;
        
        // Start the workout session
        self.healthStore.start(self.workoutSession!)
        
        // This is the type you want updates on. It can be any health kit type, including heart rate.
        let heartRateType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)
        
        // Match samples with a start date after the workout start
        let predicate = HKQuery.predicateForSamples(withStart: workoutStartDate, end: nil, options: [])
       /*
        let query = HKAnchoredObjectQuery(type: heartRateType!,
                                          predicate: nil,
                                          anchor: self.anchor,
                                          limit: Int(HKObjectQueryNoLimit)) { [unowned self](query, newSamples, deletedSamples, newAnchor, error) -> Void in
                                            
                                            guard let samples = newSamples as? [HKQuantitySample], let deleted = deletedSamples else {
                                                // Add proper error handling here...
                                                print("*** Unable to query for step counts: \(error?.localizedDescription) ***")
                                                abort()
                                            }
                                            
                                            // Process the results...
                                            self.anchor = newAnchor
                                            
                                            for sample in samples {
                                                self.addStepCountSample(sample)
                                            }
                                            
                                            for deletedSample in deleted {
                                                self.removeStepCountSample(deletedSample)
                                            }
                                            
                                            print("Done!")
                     */
        
        let heartRateQuery = HKAnchoredObjectQuery(type: heartRateType!,
                                                   predicate: predicate,
                                                   anchor: HKQueryAnchor(fromValue: Int(HKAnchoredObjectQueryNoAnchor)),
                                                   limit: 0) { [unowned self](query, newSamples, deletedSamples, newAnchor, error) -> Void in
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
        self.healthStore.execute(heartRateQuery)
    }
    
}

extension ViewController: HKWorkoutSessionDelegate{
    public func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        print(toState)
    }
    
    public func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        print(error)
    }
}

