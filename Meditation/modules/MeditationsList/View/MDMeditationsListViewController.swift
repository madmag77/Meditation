//
//  MeditationsListMDMeditationsListViewController.swift
//  Meditation
//
//  Created by Artem on 25/06/2017.
//  Copyright © 2017 MagMag77. All rights reserved.
//

import UIKit

class MeditationsListViewController: UIViewController, MeditationsListViewInput {

    @IBOutlet weak var listOfMeditations: UICollectionView!
    var output: MeditationsListViewOutput!
    var dataSource: DataSource?
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        createUIelements()
        output.viewIsReady()
    }
    
    func createUIelements() {
        dataSource = IGListKitDataSourceBuilder.build(with: listOfMeditations, viewController: self, emptyView: nil)
    }

    // MARK: MeditationsListViewInput
    func setupInitialState() {
    }
}
