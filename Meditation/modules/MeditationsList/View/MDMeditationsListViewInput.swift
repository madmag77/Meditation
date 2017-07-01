//
//  MeditationsListMDMeditationsListViewInput.swift
//  Meditation
//
//  Created by Artem on 25/06/2017.
//  Copyright © 2017 MagMag77. All rights reserved.
//

protocol MeditationsListViewInput: class {
    var dataSource: DataSource? {get set}
    func setupInitialState()
}
