//
//  MeditationListSectionController.swift
//  Meditation
//
//  Created by Artem Goncharov on 25/06/2017.
//  Copyright © 2017 MadMag. All rights reserved.
//

import Foundation
import IGListKit

public let formatter: DateFormatter = DateFormatter()
func getFormatter() -> DateFormatter {
    formatter.dateFormat = "dd MMM HH:mm"
    return formatter
}

class MeditationListSectionController: ListSectionController {
    var model: MeditationModel?
    
    override init() {
        super.init()
    }
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: (collectionContext?.containerSize.width)! - 50, height: 40)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell: MeditationListViewCell = collectionContext?.dequeueReusableCellFromStoryboard(withIdentifier: "MeditationListViewCellIdentifier", for: self, at: index) as! MeditationListViewCell
        cell.periodLabel.text = "\(getFormatter().string(from: (model?.startDate)!)) - \(getFormatter().string(from: (model?.endDate)!))"
        cell.sourceLabel.text = model?.source
        
        return cell
    }
    
    override func didUpdate(to object: Any) {
        model = object as? MeditationModel ?? nil
    }
    
    override func didSelectItem(at index: Int) {
        
    }
    
}
