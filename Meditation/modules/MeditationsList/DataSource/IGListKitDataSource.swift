//
//  IGListKitDataSource.swift
//  Meditation
//
//  Created by Artem Goncharov on 25/06/2017.
//  Copyright © 2017 MadMag. All rights reserved.
//

import Foundation
import UIKit
import IGListKit

class MeditationModel: ListDiffable {
    let identifier: NSString
    let source: String
    let startDate: Date
    let endDate: Date
    
    init(identifier: NSString, source: String, startDate: Date, endDate: Date) {
        self.identifier = identifier
        self.source = source
        self.startDate = startDate
        self.endDate = endDate
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return identifier
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? MeditationModel else {
            return false
        }
        
        return self.identifier == object.identifier
    }
    
    
}

protocol DataSource {
    var models: [ListDiffable]? {get set}
    func update()
}

class IGListKitDataSourceBuilder {
    static func build(with collectionView: UICollectionView, viewController: UIViewController, emptyView: UIView?) -> DataSource {
        return IGListKitDataSource(with: collectionView, viewController: viewController, emptyView: emptyView)
    }
}

class IGListKitDataSource: NSObject, DataSource {
    
    var adapter: ListAdapter?
    var models: [ListDiffable]?
    var emptyView: UIView?
    
    init(with collectionView: UICollectionView, viewController: UIViewController, emptyView: UIView?) {
        super.init()
        adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: viewController)
        adapter?.dataSource = self
        adapter?.collectionView = collectionView
        adapter?.collectionView?.collectionViewLayout = ListCollectionViewLayout(stickyHeaders: false, topContentInset: 0, stretchToEdge: false)
        self.emptyView = emptyView
    }
    
    func update() {
        adapter?.reloadData(completion: nil)
    }
}

extension IGListKitDataSource: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return models ?? []
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return MeditationListSectionController()
    }
    
    @available(iOS 2.0, *)
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return emptyView
    }
}
