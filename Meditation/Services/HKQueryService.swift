//
//  HKQueryService.swift
//  Meditation
//
//  Created by Artem Goncharov on 25/06/2017.
//  Copyright © 2017 MadMag. All rights reserved.
//

import Foundation
import HealthKit

enum HKQueryError: Error {
    case unavailable
}

let meditationHKObjectType = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.mindfulSession)!
let heartRateHKObjectType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!

class HKQueryService {
    var healthStore: HKHealthStore = HKHealthStore()
    
    func isDataAvailable(with callback:@escaping (Error?)->()) {
        guard HKHealthStore.isHealthDataAvailable() else {
            callback(HKQueryError.unavailable)
            return
        }
        
        requestAuthorization(with: callback)
    }
    
    func meditations(from startDate: Date, to endDate: Date, listCallback: @escaping (Array<HKCategorySample>)->()) {
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
        
        let query = HKSampleQuery(sampleType: meditationHKObjectType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: nil) {
            query, results, error in
            
            guard let samples = results as? [HKCategorySample] else {
                fatalError(" The error was: \(error?.localizedDescription)");
            }
            
            DispatchQueue.main.async() {
                listCallback(samples)
                //for sample in samples {
                  //  print(sample)
//                    guard let foodName =
//                        sample.metadata?[HKMetadataKeyFoodType] as? String else {
//                            // if the metadata doesn't record the food type, just skip it.
//                            break
//                    }
//
//                    let joules = sample.quantity.doubleValueForUnit(HKUnit.jouleUnit())
//
//                    let foodItem = AAPLFoodItem.foodItemWithName(foodName, joules: joules)
//
//                    foodItems.append(foodItem)
               // }
            }
        }
        
        healthStore.execute(query)
    }
    
    func heartRateData(for workout: HKWorkout, dataCallback: (Array<Double>)->()) {
        //        // This is the type you want updates on. It can be any health kit type, including heart rate.
        //        let heartRateType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)
        //
        //        // Match samples with a start date after the workout start
        //        let predicate = HKQuery.predicateForSamples(withStart: workoutStartDate, end: nil, options: [])
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
        
        //        let heartRateQuery = HKAnchoredObjectQuery(type: heartRateType!,
        //                                                   predicate: predicate,
        //                                                   anchor: HKQueryAnchor(fromValue: Int(HKAnchoredObjectQueryNoAnchor)),
        //                                                   limit: 0) { [unowned self](query, newSamples, deletedSamples, newAnchor, error) -> Void in
        //                                                    print("query:\n")
        //                                                    for sample in newSamples! {
        //                                                        print(sample)
        //                                                    }
        //        }
        //
        //        // This is called each time a new value is entered into HealthKit (samples may be batched together for efficiency)
        //        heartRateQuery.updateHandler = { (query, samples, deletedObjects, anchor, error) -> Void in
        //            print("update:\n")
        //            for sample in samples! {
        //                print(sample)
        //            }
        //        }
        //
        //        // Start the query
        //        self.healthStore.execute(heartRateQuery)
        
    }
    
    fileprivate func requestAuthorization(with callback:@escaping (Error?)->()) {
        healthStore.requestAuthorization(toShare: [meditationHKObjectType], read: [heartRateHKObjectType, meditationHKObjectType]) { (success, error) in
            callback(success ? nil: error)
        }
    }
    
}
